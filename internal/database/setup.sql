-- Create a new database
CREATE DATABASE snippetbox;

-- Connect to the snippetbox database
\c snippetbox

-- Create a `snippets` table
CREATE TABLE IF NOT EXISTS snippets (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    created TIMESTAMP NOT NULL,
    expires TIMESTAMP NOT NULL
);

-- Add an index on the created column
CREATE INDEX idx_snippets_created ON snippets(created);

-- Create a `sessions` table
CREATE TABLE IF NOT EXISTS sessions (
	token TEXT PRIMARY KEY,
	data BYTEA NOT NULL,
	expiry TIMESTAMPTZ NOT NULL
);

-- Add an index on the expiry column
CREATE INDEX sessions_expiry_idx ON sessions(expiry);

-- Create a `users` table
-- hashed_password stores a bcrypt hash, which are always exactly 60 characters
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    hashed_password CHAR(60) NOT NULL,
    created TIMESTAMP NOT NULL DEFAULT NOW()
);

-- `email` column must be unique. This constraint creates an index automatically.
ALTER TABLE users ADD CONSTRAINT users_uc_email UNIQUE (email);

-- Create web user with password
CREATE USER web WITH PASSWORD 'pass';

-- Grant permissions to the web user
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO web;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO web;

-- Add some dummy records
INSERT INTO snippets (title, content, created, expires) VALUES (
    'An old silent pond',
    'An old silent pond...\nA frog jumps into the pond,\nsplash! Silence again.\n\n– Matsuo Bashō',
    CURRENT_TIMESTAMP AT TIME ZONE 'UTC',
    (CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + INTERVAL '365 days'
);

INSERT INTO snippets (title, content, created, expires) VALUES (
    'Over the wintry forest',
    'Over the wintry\nforest, winds howl in rage\nwith no leaves to blow.\n\n– Natsume Soseki',
    CURRENT_TIMESTAMP AT TIME ZONE 'UTC',
    (CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + INTERVAL '365 days'
);

INSERT INTO snippets (title, content, created, expires) VALUES (
    'First autumn morning',
    'First autumn morning\nthe mirror I stare into\nshows my father''s face.\n\n– Murakami Kijo',
    CURRENT_TIMESTAMP AT TIME ZONE 'UTC',
    (CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + INTERVAL '7 days'
);
