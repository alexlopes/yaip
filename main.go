package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
)

const version = "0.0.2"

func main() {
	mux := http.NewServeMux()
	mux.HandleFunc(`/app`, app)
	mux.HandleFunc("/healthz", healthz)

	port := os.Getenv("PORT")

	if port == "" {
		log.Println("PORT is required")
		os.Exit(1)
	}

	log.Printf("Server listening on port %s", port)
	log.Fatal(http.ListenAndServe(":"+port, mux))
}

func app(w http.ResponseWriter, r *http.Request) {
	log.Printf("Serving request: %s", r.URL.Path)
	host, _ := os.Hostname()

	w.Header().Set("Content-Type", "application/json")

	encoder := json.NewEncoder(w)
	encoder.SetIndent("", "  ")
	encoder.Encode(map[string]string{"app": "Infra Go App", "version": version, "hostname": host})
}

func healthz(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
}
