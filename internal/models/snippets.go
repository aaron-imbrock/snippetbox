package models

import (
	"context"
	"errors"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
)

type Snippet struct {
	ID      int
	Title   string
	Content string
	Created time.Time
	Expires time.Time
}

type SnippetModel struct {
	DB *pgxpool.Pool
}

// TODO : NEXT TIME USE THIS PATTERN
// https://github.com/jackc/pgx/wiki/Getting-started-with-pgx#using-a-connection-pool

func (m *SnippetModel) Insert(title string, content string, expires int) (int, error) {

	stmt := `INSERT INTO snippets (title, content, created, expires)
				VALUES($1, $2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '1 DAY' * $3)
				returning id`

	ctx := context.Background()

	var id int
	err := m.DB.QueryRow(ctx, stmt, title, content, expires).Scan(&id)

	if err != nil {
		return 0, err
	}

	return id, nil
}

func (m *SnippetModel) Get(id int) (Snippet, error) {
	// return Snippet{}, nil
	stmt := `SELECT id, title, content, created, expires
				FROM snippets
				WHERE expires > CURRENT_TIMESTAMP AND id = $1`

	ctx := context.Background()

	var s Snippet
	err := m.DB.QueryRow(ctx, stmt, id).Scan(&s.ID, &s.Title, &s.Content, &s.Created, &s.Expires)

	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			// Use ErrNoRecord so we encsulate the model
			return Snippet{}, ErrNoRecord
		} else {
			return Snippet{}, err
		}
	}

	return s, nil
}

// Code is likely janky
func (m *SnippetModel) Latest() ([]Snippet, error) {
	stmt := `SELECT id, title, content, created, expires
				FROM snippets
				WHERE expires > CURRENT_TIMESTAMP
				ORDER BY id DESC
				LIMIT 10;`

	ctx := context.Background()

	rows, err := m.DB.Query(ctx, stmt)

	if err != nil {
		return nil, err
	}

	defer rows.Close()

	var snippets []Snippet

	for rows.Next() {
		var s Snippet
		err := rows.Scan(&s.ID, &s.Title, &s.Content, &s.Created, &s.Expires)
		if err != nil {
			return nil, err
		}
		snippets = append(snippets, s)
	}
	return snippets, nil
}
