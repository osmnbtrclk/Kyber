package models

import "github.com/ArmchairDevelopers/Kyber/API/api/v1/pbapi"

type StatsSource string

const (
	StatsSourceEA       StatsSource = "ea"
	StatsSourceKyber    StatsSource = "official"
	StatsSourcePersonal StatsSource = "personal"
)

func (s StatsSource) IsValid() bool {
	switch s {
	case StatsSourceEA, StatsSourceKyber, StatsSourcePersonal:
		return true
	default:
		return false
	}
}

type UserStats map[string]float64

type UserStatsModel struct {
	UserID string      `bson:"user_id"`
	Source StatsSource `bson:"source"`
	Stats  UserStats   `bson:"stats"`
}

func StatsSourceFromProto(p pbapi.StatsSource) StatsSource {
	switch p {
	case pbapi.StatsSource_EA_PC:
		return StatsSourceEA
	case pbapi.StatsSource_EA_XBOX:
		return StatsSourceEA
	case pbapi.StatsSource_EA_PS4:
		return StatsSourceEA
	case pbapi.StatsSource_KYBER:
		return StatsSourceKyber
	case pbapi.StatsSource_PERSONAL:
		return StatsSourcePersonal
	default:
		// fallback to Personal if unknown
		return StatsSourcePersonal
	}
}

func FromProtoStats(in map[string]float32) map[string]float64 {
	out := make(map[string]float64, len(in))
	for k, v := range in {
		out[k] = float64(v)
	}
	return out
}

func ConvertStats(in map[string]float64) map[string]float32 {
	out := make(map[string]float32, len(in))
	for k, v := range in {
		out[k] = float32(v)
	}
	return out
}
