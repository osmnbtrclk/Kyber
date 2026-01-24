package api

import (
	"encoding/json"
	"net/http"

	"go.uber.org/zap"

	"github.com/ArmchairDevelopers/Kyber/API/pkg/jwts"
	"github.com/ArmchairDevelopers/Kyber/API/pkg/logger"
)

func JWKSHandler(jwtService *jwts.Service) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		jwks := jwtService.ToJWKS()

		w.Header().Set("Content-Type", "application/json")
		w.Header().Set("Cache-Control", "public, max-age=360")

		if err := json.NewEncoder(w).Encode(jwks); err != nil {
			logger.L().Error("failed to encode JWKS", zap.Error(err))
			http.Error(w, "internal error", http.StatusInternalServerError)
			return
		}
	}
}
