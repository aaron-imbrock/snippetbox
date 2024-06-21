package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	const PORT = 4000
	mux := http.NewServeMux()
	mux.HandleFunc("/", home)
	mux.HandleFunc("/snippet/view", snippetView)
	mux.HandleFunc("/snippet/create", snippetCreate)

	log.Printf("Starting server on http://localhost:%d", PORT)
	err := http.ListenAndServe(fmt.Sprintf("localhost:%d", PORT), mux)
	if err != nil {
		log.Fatal(err)
	}
}
