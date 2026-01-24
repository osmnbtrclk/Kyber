package discord

import (
	"fmt"
	"os"
	"time"

	"github.com/ArmchairDevelopers/Kyber/API/pkg/models"
	"github.com/bwmarrin/discordgo"
)

type Helper struct {
	session *discordgo.Session
}

func NewHelper() *Helper {
	botToken := os.Getenv("DISCORD_BOT_TOKEN")

	if botToken == "" {
		return nil
	}

	session, err := discordgo.New("Bot " + botToken)
	if err != nil {
		return nil
	}

	return &Helper{
		session: session,
	}
}

func (d *Helper) FetchUser(userID string) (*discordgo.User, error) {
	user, err := d.session.User(userID)
	if err != nil {
		return nil, fmt.Errorf("failed to fetch user: %w", err)
	}

	return user, nil
}

func (d *Helper) GenerateUserData(user *discordgo.User) *models.DiscordData {
	return &models.DiscordData{
		ID:            user.ID,
		AvatarHash:    user.Avatar,
		Username:      user.Username,
		Discriminator: user.Discriminator,
		GlobalName:    user.GlobalName,
		LastUpdated:   time.Now(),
	}
}
