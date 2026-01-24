package jwts

import (
	"crypto/rsa"
	"crypto/sha256"
	"crypto/x509"
	"encoding/base32"
	"encoding/base64"
	"math/big"
	"strings"
)

type JWK struct {
	Kty string `json:"kty"`
	Use string `json:"use"`
	Kid string `json:"kid"`
	N   string `json:"n"`
	E   string `json:"e"`
	Alg string `json:"alg"`
}

type JWKS struct {
	Keys []JWK `json:"keys"`
}

func (s *Service) ToJWKS() JWKS {
	publicKey := s.GetPublicKey()
	keyID := s.GetKeyID()

	if publicKey == nil {
		return JWKS{
			Keys: []JWK{},
		}
	}

	jwk := rsaPublicKeyToJWK(publicKey, keyID)

	return JWKS{
		Keys: []JWK{jwk},
	}
}

func rsaPublicKeyToJWK(pubKey *rsa.PublicKey, kid string) JWK {
	if pubKey == nil {
		return JWK{}
	}

	n := base64.RawURLEncoding.EncodeToString(pubKey.N.Bytes())
	e := base64.RawURLEncoding.EncodeToString(big.NewInt(int64(pubKey.E)).Bytes())

	return JWK{
		Kty: "RSA",
		Use: "sig",
		Kid: kid,
		N:   n,
		E:   e,
		Alg: "RS256",
	}
}

func ComputeKeyID(pub *rsa.PublicKey) (string, error) {
	derBytes, err := x509.MarshalPKIXPublicKey(pub)
	if err != nil {
		return "", err
	}

	hash := sha256.Sum256(derBytes)
	trunc := hash[:30]
	enc := base32.StdEncoding.WithPadding(base32.NoPadding).EncodeToString(trunc)
	parts := make([]string, 0, len(enc)/4)
	for i := 0; i < len(enc); i += 4 {
		end := i + 4
		if end > len(enc) {
			end = len(enc)
		}
		parts = append(parts, enc[i:end])
	}
	return strings.Join(parts, ":"), nil
}
