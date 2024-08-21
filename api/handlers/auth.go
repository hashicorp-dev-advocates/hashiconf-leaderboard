package handlers

import (
	"crypto/sha256"
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"github.com/golang-jwt/jwt/v4"
	"github.com/hashicorp-dev-advocates/hashiconf-leaderboard/api/data"
	"github.com/hashicorp/go-hclog"
)

const jwtSecret = "test"

// Auth-
type Auth struct {
	con data.Connection
	log hclog.Logger
}

// AuthResponse -
type AuthResponse struct {
	UserID   int    `json:"user_id,omitempty"`
	Username string `json:"username,omitempty"`
	Token    string `json:"token,omitempty"`
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
			tokenString, err := c.generateJWTToken(users[0].ID, users[0].Username)
			if err != nil {
				c.log.Error("Unable to generate JWT token", "error", err)
				http.Error(rw, "Unable to generate JWT token", http.StatusInternalServerError)
				return
			}

			json.NewEncoder(rw).Encode(AuthResponse{
				UserID:   users[0].ID,
				Username: users[0].Username,
				Token:    tokenString,
			})
			return
		}
	}

	rw.Header().Set("WWW-Authenticate", `Basic realm="restricted", charset="UTF-8"`)
	http.Error(rw, "Unable to authenticate user", http.StatusUnauthorized)
}

// Logout signs out a user and invalidates a JWT token
func (c *Auth) Logout(rw http.ResponseWriter, r *http.Request) {
	c.log.Info("Handle Auth | Logout")

	authToken := r.Header.Get("Authorization")

	if err := c.invalidateJWTToken(authToken); err != nil {
		c.log.Error("Unable to sign out user", "error", err)
		http.Error(rw, "Unable to sign out user", http.StatusInternalServerError)
		return
	}

	fmt.Fprintf(rw, "%s", "Signed out user")
}

func (c *Auth) generateJWTToken(userID int, username string) (string, error) {
	t, err := c.con.CreateToken(userID)
	if err != nil {
		return "", err
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"token_id": t.ID,
		"user_id":  userID,
		"username": username,
		"exp":      time.Now().Add(time.Hour * 24).Unix(),
	})

	return token.SignedString([]byte(jwtSecret))
}

func (c *Auth) invalidateJWTToken(authToken string) error {
	tokenID, userID, err := ExtractJWT(authToken)
	if err != nil {
		return err
	}
	if err = c.con.DeleteToken(tokenID, userID); err != nil {
		return err
	}
	return nil
}

// ExtractJWT retrieves the token and user ID from the JWT
func ExtractJWT(authToken string) (int, int, error) {
	token, err := jwt.Parse(authToken, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, nil
		}
		return []byte(jwtSecret), nil
	})

	if err != nil {
		return -1, -1, err
	}

	if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
		tokenID := int(claims["token_id"].(float64))
		userID := int(claims["user_id"].(float64))
		return tokenID, userID, nil
	}
	return -1, -1, nil
}

func (c *Auth) VerifyJWT(authToken string) (int, error) {
	tokenID, userID, err := ExtractJWT(authToken)
	if err != nil {
		return userID, err
	}
	if _, err := c.con.GetToken(tokenID, userID); err != nil {
		return userID, err
	}
	return userID, nil
}

// IsAuthorized
func (c *Auth) IsAuthorized(next func(userID int, w http.ResponseWriter, r *http.Request)) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		authToken := r.Header.Get("Authorization")
		userID, err := c.VerifyJWT(authToken)
		if err == nil {
			next(userID, w, r)
			return
		}
		c.log.Error("Unauthorized", "error", err)
		http.Error(w, err.Error(), http.StatusUnauthorized)
	})
}
