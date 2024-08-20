package handlers

import (
	"crypto/sha256"
	"fmt"
	"net/http"

	"github.com/hashicorp-dev-advocates/hashiconf-leaderboard/api/data"
	"github.com/hashicorp/go-hclog"
)

// Auth-
type Auth struct {
	con data.Connection
	log hclog.Logger
}

// NewAuth-
func NewAuth(con data.Connection, l hclog.Logger) *Auth {
	return &Auth{con, l}
}

// Login checks if the user is able to authenticate
func (c *Auth) Login(rw http.ResponseWriter, r *http.Request) {
	c.log.Info("Handle Auth | Login")

	username, password, ok := r.BasicAuth()
	if ok {
		users, err := c.con.GetUser(username)
		if err != nil {
			c.log.Error("Unable to get username in database", "error", err)
			http.Error(rw, "Unable to authenticate user", http.StatusUnauthorized)
			return
		}

		if len(users) == 0 {
			c.log.Error("Username not found in database", "error", err)
			http.Error(rw, "Unable to authenticate user", http.StatusUnauthorized)
			return
		}

		passwordHash := sha256.Sum256([]byte(password))
		expectedPasswordHash := sha256.Sum256([]byte(users[0].Password))
		if passwordHash == expectedPasswordHash {
			fmt.Fprintf(rw, "%s", "authenticated")
			return
		}
	}

	rw.Header().Set("WWW-Authenticate", `Basic realm="restricted", charset="UTF-8"`)
	http.Error(rw, "Unable to authenticate user", http.StatusUnauthorized)
}
