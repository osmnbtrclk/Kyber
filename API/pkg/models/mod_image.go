package models

import (
	"time"
)

type ImageHashStatus string

const (
	ImageHashStatusPending  ImageHashStatus = "PENDING"
	ImageHashStatusApproved ImageHashStatus = "APPROVED"
	ImageHashStatusRejected ImageHashStatus = "REJECTED"
)

type ModImageModel struct {
	ID        string             `json:"id" bson:"_id"`
	Data      []byte             `json:"data,omitempty" bson:"data,omitempty"`
	Levels    []string           `json:"levels" bson:"levels"`
	Modes     []string           `json:"modes" bson:"modes"`
	Status    ImageHashStatus    `json:"status" bson:"status"`
	Mods      []ModImageModModel `json:"mods" bson:"mods"`
	UseCount  int                `json:"use_count" bson:"use_count"`
	LastUsed  time.Time          `json:"last_used" bson:"last_used"`
	CreatedAt time.Time          `json:"created_at" bson:"created_at"`
}

type ModImageModModel struct {
	Name    string `json:"name" bson:"name"`
	Version string `json:"version" bson:"version"`
}
