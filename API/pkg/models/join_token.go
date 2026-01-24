package models

import "time"

type JoinTokenModel struct {
	ID      string    `json:"id" bson:"_id"`
	Token   string    `json:"token" bson:"token"`
	User    string    `json:"user" bson:"user"`
	Server  string    `json:"server" bson:"server"`
	Created time.Time `json:"created" bson:"created"`
}
