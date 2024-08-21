package data

import (
	"github.com/stretchr/testify/mock"
)

type MockConnection struct {
	mock.Mock
}

// IsConnected -
func (c *MockConnection) IsConnected() (bool, error) {
	return true, nil
}

// GetTeams -
func (c *MockConnection) GetTeams(*int) (Teams, error) {
	args := c.Called()

	if m, ok := args.Get(0).(Teams); ok {
		return m, args.Error(1)
	}

	return nil, args.Error(1)
}

// GetTeamsByActivation -
func (c *MockConnection) GetTeamsByActivation(string) (Teams, error) {
	args := c.Called()

	if m, ok := args.Get(0).(Teams); ok {
		return m, args.Error(1)
	}

	return nil, args.Error(1)
}

// CreateTeam -
func (c *MockConnection) CreateTeam(team *Team) (Team, error) {
	args := c.Called()

	if m, ok := args.Get(0).(Team); ok {
		return m, args.Error(1)
	}

	return Team{}, args.Error(1)
}

// DeleteTeam -
func (c *MockConnection) DeleteTeam(teamId int) error {
	args := c.Called()

	if err, ok := args.Get(0).(error); ok {
		return err
	}

	return nil
}

// GetUser -
func (c *MockConnection) GetUser(string) (Users, error) {
	args := c.Called()

	if m, ok := args.Get(0).(Users); ok {
		return m, args.Error(1)
	}

	return nil, args.Error(1)
}

// CreateToken -
func (c *MockConnection) CreateToken(userID int) (Token, error) {
	args := c.Called()

	if m, ok := args.Get(0).(Token); ok {
		return m, args.Error(1)
	}

	return Token{}, args.Error(1)
}

// GetToken -
func (c *MockConnection) GetToken(tokenID int, userID int) (Token, error) {
	args := c.Called()

	if m, ok := args.Get(0).(Token); ok {
		return m, args.Error(1)
	}

	return Token{}, args.Error(1)
}

// DeleteToken -
func (c *MockConnection) DeleteToken(tokenID int, userID int) error {
	args := c.Called()

	if err, ok := args.Get(0).(error); ok {
		return err
	}

	return nil
}
