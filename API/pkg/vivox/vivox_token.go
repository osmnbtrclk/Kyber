package vivox

import (
	"crypto/hmac"
	"crypto/sha256"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"os"
	"sync"
	"time"
)

type TokenRequest struct {
	Iss string  `json:"iss"`
	Exp uint64  `json:"exp"`
	Vxa string  `json:"vxa"`
	Vxi uint64  `json:"vxi"`
	F   string  `json:"f"`
	T   *string `json:"t,omitempty"`
}

type VivoxTokenGenerator struct {
	mu       sync.Mutex
	reqIndex uint64
	Key      string
	Domain   string
	Issuer   string
}

func NewVivoxTokenGenerator() *VivoxTokenGenerator {
	key := os.Getenv("VIVOX_KEY")
	if key == "" {
		panic("Please set VIVOX_KEY environment variable")
	}
	issuer := os.Getenv("VIVOX_ISSUER")
	if issuer == "" {
		panic("Please set VIVOX_ISSUER environment variable")
	}

	domain := os.Getenv("VIVOX_DOMAIN")
	if domain == "" {
		panic("Please set VIVOX_DOMAIN environment variable")
	}

	return &VivoxTokenGenerator{
		Key:    key,
		Issuer: issuer,
		Domain: domain,
	}
}

func (g *VivoxTokenGenerator) Generate(action, from string, to *string) string {
	g.mu.Lock()
	defer g.mu.Unlock()

	header := base64.RawURLEncoding.EncodeToString([]byte("{}"))
	tr := TokenRequest{
		Iss: g.Issuer,
		Exp: uint64(time.Now().Unix()) + 10000,
		Vxa: action,
		Vxi: g.reqIndex,
		F:   from,
		T:   to,
	}
	payloadJSON, err := json.Marshal(tr)
	if err != nil {
		panic("failed to serialize Vivox token payload: " + err.Error())
	}
	payload := base64.RawURLEncoding.EncodeToString(payloadJSON)

	toSign := header + "." + payload

	mac := hmac.New(sha256.New, []byte(g.Key))
	mac.Write([]byte(toSign))
	signature := mac.Sum(nil)
	sigEncoded := base64.RawURLEncoding.EncodeToString(signature)

	g.reqIndex++

	return toSign + "." + sigEncoded
}

func (g *VivoxTokenGenerator) Username(username string) string {
	return fmt.Sprintf(".%s.%s.", g.Issuer, username)
}

func (g *VivoxTokenGenerator) UserURI(username string) string {
	return fmt.Sprintf("sip:%s@%s", username, g.Domain)
}

func (g *VivoxTokenGenerator) PositionalChannelURI(
	channel string,
	maxRange, clampingDistance, rolloff, distanceModel uint32,
) string {
	return fmt.Sprintf(
		"sip:confctl-d-%s.%s!p-%d-%d-%d-%d@%s",
		g.Issuer, channel,
		maxRange, clampingDistance, rolloff, distanceModel,
		g.Domain,
	)
}
