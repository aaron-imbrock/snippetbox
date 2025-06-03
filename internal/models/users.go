package models

import (
	"context"
	"errors"
	"strings"
	"time"

	"github.com/jackc/pgx/v5/pgconn"
	"github.com/jackc/pgx/v5/pgxpool"
	"golang.org/x/crypto/bcrypt"
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
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), 12)
	if err != nil {
		return err
	}

	// created column in users uses DEFAULT NOW(),
	// thus we don't need to explicitly provide a value for it.
	stmt := `INSERT INTO users (name, email, hashed_password) VALUES($1, $2, $3)`

	_, err = m.DB.Exec(context.Background(), stmt, name, email, string(hashedPassword))
	if err != nil {
		// fmt.Printf("type: %T\n", err)
		// fmt.Printf("contents: %#v\n", err)
		// if err returns an error, we use the errors.As() function to check whether the error is
		// of type *pgconn.Pgerror.
		// https://www.postgresql.org/docs/current/errcodes-appendix.html
		// 23505 unique_violation
		var pgErr *pgconn.PgError
		if errors.As(err, &pgErr) {
			// fmt.Printf("\nInside &pgErr block\n\n")
			// fmt.Printf("\ncontents:%s\n\n", pgErr.Detail)
			if pgErr.Code == "23505" && strings.Contains(pgErr.Detail, "already exists") {
				// fmt.Printf("\npgErr.Code == 23505\n")
				return ErrDuplicateEmail
			}
		}
		return err
	}
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
