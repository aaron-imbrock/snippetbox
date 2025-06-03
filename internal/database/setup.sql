-- Create a new database
CREATE DATABASE snippetbox;

-- Connect to the snippetbox database
\c snippetbox

-- Create a `snippets` table for storing code snippets
-- Using TIMESTAMPTZ for consistent timezone handling
CREATE TABLE IF NOT EXISTS snippets (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    created TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expires TIMESTAMPTZ NOT NULL
);

-- Add constraints for data integrity
ALTER TABLE snippets ADD CONSTRAINT snippets_expires_after_created
    CHECK (expires > created);

-- Add indexes for performance optimization
CREATE INDEX idx_snippets_created ON snippets(created);
-- Index for active snippets - using CURRENT_TIMESTAMP instead of NOW() for immutability
-- Or alternatively, just index on expires without the WHERE clause
CREATE INDEX idx_snippets_expires ON snippets(expires);

-- Create a `sessions` table for user session management
CREATE TABLE IF NOT EXISTS sessions (
    token TEXT PRIMARY KEY,
    data BYTEA NOT NULL,
    expiry TIMESTAMPTZ NOT NULL
);

-- Add an index on the expiry column for cleanup operations
CREATE INDEX sessions_expiry_idx ON sessions(expiry);

-- Create a `users` table for authentication
-- hashed_password stores a bcrypt hash, which are always exactly 60 characters
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    hashed_password CHAR(60) NOT NULL,
    created TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Add constraints for data integrity
ALTER TABLE users ADD CONSTRAINT users_email_not_empty
    CHECK (length(trim(email)) > 0);

ALTER TABLE users ADD CONSTRAINT users_name_not_empty
    CHECK (length(trim(name)) > 0);

-- Create web user with password for application access
CREATE USER web WITH PASSWORD 'pass';

-- Grant comprehensive permissions to the web user
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO web;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO web;

-- Grant permissions on future tables and sequences (PostgreSQL 10+)
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO web;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT USAGE, SELECT ON SEQUENCES TO web;

-- Add some dummy records for testing
INSERT INTO snippets (title, content, created, expires) VALUES (
    'An old silent pond',
    'An old silent pond...' || E'\n' ||
    'A frog jumps into the pond,' || E'\n' ||
    'splash! Silence again.' || E'\n\n' ||
    '– Matsuo Bashō',
    NOW(),
    NOW() + INTERVAL '365 days'
);

INSERT INTO snippets (title, content, created, expires) VALUES (
    'Over the wintry forest',
    'Over the wintry' || E'\n' ||
    'forest, winds howl in rage' || E'\n' ||
    'with no leaves to blow.' || E'\n\n' ||
    '– Natsume Soseki',
    NOW(),
    NOW() + INTERVAL '365 days'
);

INSERT INTO snippets (title, content, created, expires) VALUES (
    'First autumn morning',
    'First autumn morning' || E'\n' ||
    'the mirror I stare into' || E'\n' ||
    'shows my father''s face.' || E'\n\n' ||
    '– Murakami Kijo',
    NOW(),
    NOW() + INTERVAL '7 days'
);

-- Create a test user for development
INSERT INTO users (name, email, hashed_password) VALUES (
    'Test User',
    'test@example.com',
    '$2a$12$NuTjWXm3KKntReFwyBVHyuf/to.HEwTy.eS206TNfkGfr6HzGJSWG'
);

-- Display table information
\d+ snippets
\d+ sessions
\d+ users

-- Show granted permissions
SELECT grantee, table_name, privilege_type
FROM information_schema.role_table_grants
WHERE grantee = 'web' AND table_schema = 'public';

SELECT grantee, object_name, privilege_type
FROM information_schema.role_usage_grants
WHERE grantee = 'web' AND object_schema = 'public';
