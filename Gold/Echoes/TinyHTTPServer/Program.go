package TinyHTTPServer

// http server, with a handler for '/hello' path
// to test just browse to http://127.0.0.1:6789/hello

import (
	 "net/http"
	 "log"
)

// function to handle /hello path, in this case showing "This is an example server"
func HelloServer(w http.ResponseWriter, req *http.Request) {
	w.Header().Set("Content-Type", "text/plain")
	w.Write([]byte("This is an example server.\n"))
}

func main() {
	// add handler func HelloServer for "/hello" path
	http.HandleFunc("/hello", HelloServer)
	// listen on 6789 port
	err := http.ListenAndServe(":6789", nil);

	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}