package TinySecureHTTPServer

// https server, with a handler for '/hello' path.
// to test, browse to https://127.0.0.1/hello
// to generate server.crt and server.key (self signed certificate, need to accept browser warning about it), use a linux machine:
// openssl genrsa -out https-server.key 2048
// openssl ecparam -genkey -name secp384r1 -out https-server.key
// openssl req -new -x509 -sha256 -key https-server.key -out https-server.crt -days 3650

import (
	"net/http"
	"log"
)

func HelloServer(w http.ResponseWriter, req *http.Request) {
	w.Header().Set("Content-Type", "text/plain")
	w.Write([]byte("This is an example server.\n"))
}

func main() {
	http.HandleFunc("/hello", HelloServer)
	err := http.ListenAndServeTLS(":443", "server.crt", "server.key", nil)

	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}