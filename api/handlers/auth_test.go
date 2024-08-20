package handlers

import (
	"errors"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/hashicorp-dev-advocates/hashiconf-leaderboard/api/data"
	"github.com/hashicorp/go-hclog"
	"github.com/stretchr/testify/assert"
)

func setupAuthHandler(_ *testing.T) (*Auth, *httptest.ResponseRecorder) {
	c := &data.MockConnection{}

	testUser := data.User{
		ID:       1,
		Username: "test",
		Password: "test123",
	}

	c.On("GetUser").Return(data.Users{testUser}, nil)

	l := hclog.Default()

	return &Auth{c, l}, httptest.NewRecorder()
}

func setupFailedAuthHandler(_ *testing.T) (*Auth, *httptest.ResponseRecorder) {
	c := &data.MockConnection{}

	c.On("GetUser").Return(nil, errors.New("Unable to retrieve team"))

	l := hclog.Default()

	return &Auth{c, l}, httptest.NewRecorder()
}

// TestReturnsUser - Tests success criteria
func TestReturnsUser(t *testing.T) {
	c, rw := setupAuthHandler(t)

	r := httptest.NewRequest("GET", "/login", nil)
	r.SetBasicAuth("test", "test123")

	c.Login(rw, r)

	assert.Equal(t, http.StatusOK, rw.Code)
}

// TestFailsNoUser - Tests error
func TestFailsNoUser(t *testing.T) {
	c, rw := setupFailedAuthHandler(t)

	r := httptest.NewRequest("GET", "/login", nil)

	c.Login(rw, r)

	assert.Equal(t, http.StatusUnauthorized, rw.Code)
}
