package models

import "time"

type HostedMod struct {
	ID         string             `json:"id" bson:"_id,omitempty"`
	Name       string             `json:"name" bson:"name"`
	Version    string             `json:"version" bson:"version"`
	UploaderID string             `json:"uploader_id" bson:"uploader_id"`
	Mods       *[]NestedHostedMod `json:"mods" bson:"mods"`
	FileName   string             `json:"file_name" bson:"file_name"`
	TotalSize  uint64             `json:"total_size" bson:"total_size"`
	Created    time.Time          `json:"created" bson:"created"`
	Updated    time.Time          `json:"updated" bson:"updated"`
}

type NestedHostedMod struct {
	Name    string `json:"name" bson:"name"`
	Version string `json:"version" bson:"version"`
	Size    uint64 `json:"size" bson:"size"`
}
