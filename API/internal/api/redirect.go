package api

import (
	"fmt"
	"net/http"
	"net/url"

	"github.com/ArmchairDevelopers/Kyber/API/pkg/logger"
)

func RedirectHandler(w http.ResponseWriter, r *http.Request) {
	targetRoute := r.URL.Query().Get("target")
	if targetRoute == "" {
		http.Error(w, "target query parameter is required", http.StatusBadRequest)
		return
	}

	decoded, err := url.QueryUnescape(targetRoute)
	if err != nil {
		logger.L().Error(err.Error())
		http.Error(w, "failed to decode target parameter", http.StatusBadRequest)
		return
	}

	target := fmt.Sprintf("kl://%s", decoded)
	http.Redirect(w, r, target, http.StatusTemporaryRedirect)
}
