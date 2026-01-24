package api

import (
	"net/http"
	"os"

	"github.com/ArmchairDevelopers/Kyber/API/pkg/db"
	"github.com/ArmchairDevelopers/Kyber/API/pkg/logger"
	"github.com/ArmchairDevelopers/Kyber/API/pkg/models"
	"github.com/gorilla/mux"
	"go.uber.org/zap"
)

type ImageManager struct {
	store *db.Store
	token string
}

func NewImageManager(store *db.Store) *ImageManager {
	token := os.Getenv("IMAGE_API_TOKEN")

	if token == "" {
		logger.L().Warn("IMAGE_API_TOKEN is not set; image API may be unsecured")
	}

	return &ImageManager{
		store: store,
		token: token,
	}
}

func (d *ImageManager) ImageHandler(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id := vars["id"]
	token := r.URL.Query().Get("token")

	if id == "" {
		logger.L().Error("Image ID is required", zap.String("id", id))
		http.Error(w, "Image ID is required", http.StatusBadRequest)
		return
	}

	var err error
	var image *models.ModImageModel
	if token == d.token {
		image, err = d.store.ModImages.GetByID(r.Context(), id)
		if err != nil {
			logger.L().Error("Failed to get image by ID", zap.Error(err), zap.String("id", id))
			http.Error(w, "Failed to get image", http.StatusInternalServerError)
			return
		}
	} else {
		image, err = d.store.ModImages.Search(r.Context(), id)
		if err != nil {
			logger.L().Error("Failed to search image by ID", zap.Error(err), zap.String("id", id))
			http.Error(w, "Failed to search image", http.StatusInternalServerError)
			return
		}
	}

	if image == nil {
		http.Error(w, "Image not found", http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "image/jpeg")
	if _, err := w.Write(image.Data); err != nil {
		logger.L().Error("Failed to write image data", zap.Error(err))
		http.Error(w, "Failed to write image data", http.StatusInternalServerError)
		return
	}
}
