package util

import (
	"crypto/rand"
	"encoding/hex"
	"fmt"
)

func GenerateToken() string {
	b := make([]byte, 16)
	if _, err := rand.Read(b); err != nil {
		panic(fmt.Sprintf("failed to generate token: %v", err))
	}
	return hex.EncodeToString(b)
}

func GenerateShortToken() string {
	b := make([]byte, 8)
	if _, err := rand.Read(b); err != nil {
		panic(fmt.Sprintf("failed to generate short token: %v", err))
	}
	return hex.EncodeToString(b)
}
