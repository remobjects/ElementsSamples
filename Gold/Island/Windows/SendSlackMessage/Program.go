package SendSlackMessage

import (
    "bytes"
    "encoding/json"
    "errors"
    "log"
    "net/http"
    "io/ioutil"
    "os"
    "time"
)

type SlackRequestBody struct {
    Text string `json:"text"`
}

// localFixture is an in-memory HTTP transport: the default run sends no network traffic.
// The real client uses its normal transport when SLACK_WEBHOOK_URL is configured.
type localFixture struct {}

func (fixture localFixture) RoundTrip(req *http.Request) (*http.Response, error) {
    defer req.Body.Close()
    if req.Method != http.MethodPost || req.Header.Get("Content-Type") != "application/json" {
        return nil, errors.New("Expected a JSON POST")
    }
    body, err := ioutil.ReadAll(req.Body)
    if err != nil || string(body) != `{"text":"Test Message"}` {
        return nil, errors.New("Unexpected fixture message")
    }
    return &http.Response{StatusCode: http.StatusOK, Body: ioutil.NopCloser(bytes.NewBufferString("ok")), Header: make(http.Header)}, nil
}

func main() {
    webhookURL := os.Getenv("SLACK_WEBHOOK_URL")
    client := &http.Client{Timeout: 10 * time.Second}
    if webhookURL == "" {
        webhookURL = "http://fixture.local/slack"
        client.Transport = localFixture{}
    }
    if err := SendSlackNotification(client, webhookURL, "Test Message"); err != nil {
        log.Fatal(err)
    }
    log.Print("Webhook accepted the message.")
}

func SendSlackNotification(client *http.Client, webhookURL string, msg string) error {
    slackBody, err := json.Marshal(SlackRequestBody{Text: msg})
    if err != nil {
        return err
    }
    req, err := http.NewRequest(http.MethodPost, webhookURL, bytes.NewBuffer(slackBody))
    if err != nil {
        return err
    }
    req.Header.Set("Content-Type", "application/json")
    resp, err := client.Do(req)
    if err != nil {
        return err
    }
    defer resp.Body.Close()
    buf := new(bytes.Buffer)
    if _, err := buf.ReadFrom(resp.Body); err != nil {
        return err
    }
    if resp.StatusCode != http.StatusOK || buf.String() != "ok" {
        return errors.New("Webhook did not accept the message")
    }
    return nil
}