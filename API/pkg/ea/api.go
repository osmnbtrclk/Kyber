package ea

import (
	"encoding/json"
	"errors"
	"io"
	"net/http"

	"github.com/ArmchairDevelopers/Kyber/API/pkg/logger"
	"go.uber.org/zap"
)

func IsBanned(token string) (bool, error) {
	if token == "" {
		return false, nil
	}

	client := http.Client{}
	req, err := http.NewRequest("GET", "https://gateway.ea.com/proxy/identity/pids/me/entitlements", nil)
	if err != nil {
		return false, nil
	}

	req.Header.Set("Authorization", "Bearer "+token)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("X-Expand-Results", "true")

	q := req.URL.Query()
	q.Add("groupName", "SWBF2PC")
	q.Add("entitlementTag", "ONLINE_ACCESS")
	q.Add("status", "BANNED")
	req.URL.RawQuery = q.Encode()

	resp, err := client.Do(req)
	if err != nil {
		return false, nil
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		logger.L().Error("EA entitlement check failed", zap.String("status", resp.Status), zap.String("body", string(body)))
		return false, errors.New("failed to check EA entitlements")
	}

	var entitlementResp EntitlementResponse
	err = json.NewDecoder(resp.Body).Decode(&entitlementResp)
	if err != nil {
		return false, nil
	}

	return len(entitlementResp.Entitlements.Entitlement) > 0, nil
}

type EntitlementResponse struct {
	Entitlements Entitlements `json:"entitlements"`
}

type Entitlements struct {
	Entitlement []Entitlement `json:"entitlement"`
}

type Entitlement struct {
	EntitlementID     int64   `json:"entitlementId"`
	EntitlementSource string  `json:"entitlementSource"`
	EntitlementTag    string  `json:"entitlementTag"`
	EntitlementType   string  `json:"entitlementType"`
	GrantDate         string  `json:"grantDate"`
	GroupName         string  `json:"groupName"`
	ProductCatalog    string  `json:"productCatalog"`
	ProductID         string  `json:"productId"`
	ProjectID         string  `json:"projectId"`
	StatusReasonCode  string  `json:"statusReasonCode"`
	Status            string  `json:"status"`
	TerminationDate   string  `json:"terminationDate"`
	UseCount          int64   `json:"useCount"`
	IsConsumable      bool    `json:"isConsumable"`
	PIDURI            string  `json:"pidUri"`
	OriginPermissions int64   `json:"originPermissions"`
	Version           int64   `json:"version"`
	ExternalType      *string `json:"externalType,omitempty"`
	LastModifiedDate  string  `json:"lastModifiedDate"`
}
