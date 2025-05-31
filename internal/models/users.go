package models

import (
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
)

// Confirm (additions) field names and types align
// with the columns in the db "users" table
type User struct {
	ID             int
	Name           string
	Email          string
	HashedPassword []byte
	Created        time.Time
}

type UserModel struct {
	DB *pgxpool.Pool
}

// Use the Insert method to add a new record to the "users" table.
func (m *UserModel) Insert(name, email, password string) error {
	return nil
}

// Use the Authenticate method to verify whether a user exists with
// the provided email address and password.
// This will return the relevant user ID if they do.
func (m *UserModel) Authenticate(email, password string) (int, error) {
	return 0, nil
}

// Use the Exists method to check if a user exists with a specific ID.
func (m *UserModel) Exists(id int) (bool, error) {
	return false, nil
}
