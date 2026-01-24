package models

import (
	"time"

	"github.com/ArmchairDevelopers/Kyber/API/api/v1/pbapi"
)

type ReportReason string

const (
	ReasonHacking        ReportReason = "HACKING"
	ReasonToxicBehaviour ReportReason = "TOXIC_BEHAVIOUR"
	ReasonGriefing       ReportReason = "GRIEFING"
	ReasonOther          ReportReason = "OTHER"
)

func GetReportReasonFromProto(reason pbapi.ReportReason) ReportReason {
	switch reason {
	case pbapi.ReportReason_HACKING:
		return ReasonHacking
	case pbapi.ReportReason_TOXIC_BEHAVIOUR:
		return ReasonToxicBehaviour
	case pbapi.ReportReason_GRIEFING:
		return ReasonGriefing
	case pbapi.ReportReason_OTHER:
		return ReasonOther
	default:
		return ReasonOther
	}
}

func (r *ReportReason) ToProto() pbapi.ReportReason {
	switch *r {
	case ReasonHacking:
		return pbapi.ReportReason_HACKING
	case ReasonToxicBehaviour:
		return pbapi.ReportReason_TOXIC_BEHAVIOUR
	case ReasonGriefing:
		return pbapi.ReportReason_GRIEFING
	case ReasonOther:
		return pbapi.ReportReason_OTHER
	default:
		return pbapi.ReportReason_OTHER
	}
}

type ReportStatus string

const (
	ReportStatusNew      ReportStatus = "NEW"
	ReportStatusResolved ReportStatus = "RESOLVED"
	ReportStatusRejected ReportStatus = "REJECTED"
)

func GetReportStatusFromProto(status pbapi.ReportStatus) ReportStatus {
	switch status {
	case pbapi.ReportStatus_NEW:
		return ReportStatusNew
	case pbapi.ReportStatus_RESOLVED:
		return ReportStatusResolved
	case pbapi.ReportStatus_REJECTED:
		return ReportStatusRejected
	default:
		return ReportStatusNew
	}
}

func (s *ReportStatus) ToProto() pbapi.ReportStatus {
	switch *s {
	case ReportStatusNew:
		return pbapi.ReportStatus_NEW
	case ReportStatusResolved:
		return pbapi.ReportStatus_RESOLVED
	case ReportStatusRejected:
		return pbapi.ReportStatus_REJECTED
	default:
		return pbapi.ReportStatus_NEW
	}
}

type ReportModel struct {
	ID               string       `bson:"_id,omitempty" json:"id"`
	ReporterID       string       `bson:"reporter_id" json:"reporterId"`
	ReportedPlayerID string       `bson:"reported_player_id" json:"reportedPlayerId"`
	Reason           ReportReason `bson:"reason" json:"reason"`
	Description      string       `bson:"description" json:"description"`
	EvidenceLinks    []string     `bson:"evidence_links" json:"evidenceLinks"`
	S3EvidenceIDs    []string     `bson:"s3_evidence_ids" json:"s3EvidenceIds,omitempty"`
	Status           ReportStatus `bson:"status" json:"status"`
	Notes            []ReportNote `bson:"notes" json:"notes"`
	ModeratorID      *string      `bson:"moderator_id,omitempty" json:"moderator_id,omitempty"`
	PunishmentID     *string      `bson:"punishment_id,omitempty" json:"punishmentId,omitempty"`
	CreatedAt        time.Time    `bson:"created_at" json:"createdAt"`
	UpdatedAt        time.Time    `bson:"updated_at" json:"updatedAt"`
}

type ReportNote struct {
	Note      string    `bson:"note" json:"note"`
	CreatedAt time.Time `bson:"created_at" json:"createdAt"`
	UserID    string    `bson:"user_id" json:"userId"`
}

/*func (r *ReportModel) ToProto(reporter UserModel, targetUser UserModel) *pbapi.Report {
	notes := make([]string, len(r.Notes))
	for i, note := range r.Notes {
		notes[i] = note.Note
	}

	return &pbapi.Report{
		Id:                 r.ID,
		ReportedPlayerId:   r.ReportedPlayerID,
		ReporterId:         r.ReporterID,
		Description:        r.Description,
		EvidenceLinks:      r.EvidenceLinks,
		Reason:             r.Reason.ToProto(),
		CreatedAt:          r.CreatedAt.Unix(),
		UpdatedAt:          r.UpdatedAt.Unix(),
		Status:             r.Status.ToProto(),
		Notes:              notes,
		ReportedPlayerName: &targetUser.Name,
		ReporterName:       &reporter.Name,
	}
}*/
