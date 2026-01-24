package util

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"time"
)

type VPNCheckResponse struct {
	IP        string `json:"ip"`
	Anonymous struct {
		IsVPN   bool `json:"is_vpn"`
		IsProxy bool `json:"is_proxy"`
		IsTor   bool `json:"is_tor"`
		IsRelay bool `json:"is_relay"`
	} `json:"anonymous"`
	IsAnonymous bool `json:"is_anonymous"`
}

func IsVPN(ip string) (bool, error) {
	endpoint := os.Getenv("VPN_CHECK_ENDPOINT")

	if endpoint == "" {
		return false, nil
	}

	url := fmt.Sprintf(endpoint, ip)

	client := &http.Client{
		Timeout: 5 * time.Second,
	}

	resp, err := client.Get(url)
	if err != nil {
		return false, fmt.Errorf("failed to query: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return false, fmt.Errorf("returned status %d", resp.StatusCode)
	}

	var decoded VPNCheckResponse
	if err := json.NewDecoder(resp.Body).Decode(&decoded); err != nil {
		return false, fmt.Errorf("failed to decode response: %w", err)
	}

	isVPN := decoded.Anonymous.IsVPN || decoded.Anonymous.IsProxy || decoded.Anonymous.IsTor || decoded.Anonymous.IsRelay || decoded.IsAnonymous

	return isVPN, nil
}
