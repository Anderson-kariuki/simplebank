package token

import (
	"time"
)

// Maker is an interface for managing tockens
type Maker interface {
	// CreateTocken creates a new tocken for a specific username and duration
	CreateTocken(username string, duration time.Duration) (string, error)

	// VerifyTocken checks if the tocken is valid or not
	VerifyTocken(tocken string) (*Payload, error)
}
