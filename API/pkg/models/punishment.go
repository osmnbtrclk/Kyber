package models

import (
	"fmt"
	"time"

	"github.com/ArmchairDevelopers/Kyber/API/api/v1/pbapi"
	"github.com/ArmchairDevelopers/Kyber/API/api/v1/pbcommon"
)

type PunishmentType string

const (
	PunishmentTypeKick PunishmentType = "KICK"
	PunishmentTypeBan  PunishmentType = "BAN"
)

// PunishmentModel
// Issuer is usually the host user ID for server-specific bans, or nil for global bans
// and Moderator is the user ID of the moderator who issued the punishment
type PunishmentModel struct {
	ID               string         `json:"_id" bson:"_id"`
	Type             PunishmentType `json:"type" bson:"type"`
	Issuer           *string        `json:"issuer" bson:"issuer"`
	ModeratorID      *string        `json:"moderator_id" bson:"moderator_id"`
	User             *string        `json:"user" bson:"user"`
	Reason           *string        `json:"reason" bson:"reason"`
	IssuedAt         time.Time      `json:"issued_at" bson:"issued_at"`
	ExpiresAt        *time.Time     `json:"expires_at" bson:"expires_at"`
	OverturnedBy     *string        `json:"overturned_by" bson:"overturned_by"`
	OverturnedReason *string        `json:"overturned_reason" bson:"overturned_reason"`
	LastUsedIP       *string        `json:"last_used_ip" bson:"last_used_ip"`
	DeviceIDs        *[]string      `json:"device_ids" bson:"device_ids"`
	ReportIDs        *[]string      `json:"report_ids" bson:"report_ids"`

	ModeratorModel *UserModel `json:"moderator_model,omitempty" bson:"moderator_model,omitempty"`
	UserModel      *UserModel `json:"user_model,omitempty" bson:"user_model,omitempty"`
}

func (p *PunishmentModel) IsActive() bool {
	return p.OverturnedBy == nil && (p.ExpiresAt == nil || p.ExpiresAt.After(time.Now()))
}

func (p *PunishmentModel) Proto() *pbapi.Punishment {
	var e *uint64

	if p.ExpiresAt != nil {
		e = new(uint64)
		*e = uint64(p.ExpiresAt.UnixMilli())
	}

	var t pbapi.PunishmentType
	switch p.Type {
	case PunishmentTypeKick:
		t = pbapi.PunishmentType_KICK
	case PunishmentTypeBan:
		t = pbapi.PunishmentType_BAN
	default:
		t = pbapi.PunishmentType_BAN
	}

	var user *pbcommon.KyberPlayer
	if p.UserModel != nil {
		user = p.UserModel.Proto()
	}

	var moderator *pbcommon.KyberPlayer
	if p.ModeratorModel != nil {
		moderator = p.ModeratorModel.Proto()
	}

	return &pbapi.Punishment{
		Id:        p.ID,
		Reason:    *p.Reason,
		Issuer:    p.Issuer,
		User:      user,
		Moderator: moderator,
		IssuedAt:  uint64(p.IssuedAt.UnixMilli()),
		ExpiresAt: e,
		Type:      t,
	}
}

func (p *PunishmentModel) BanMessage() string {
	reason := p.Reason
	message := ""
	if p.ExpiresAt != nil {
		message = fmt.Sprintf("You are banned until %s. Reason: %s", p.ExpiresAt.Format(time.RFC1123), *reason)
	} else {
		message = fmt.Sprintf("You are permanently banned. Reason: %s", *reason)
	}

	return message
}
