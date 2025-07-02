-- Add learned_concepts field to users table for tracking learning progress
-- This stores an array of concept strings that the user has already learned

ALTER TABLE users ADD COLUMN learned_concepts JSONB DEFAULT '[]'::jsonb;

-- Add index for performance when querying learned concepts
CREATE INDEX idx_users_learned_concepts ON users USING GIN (learned_concepts);

-- Add comment for documentation
COMMENT ON COLUMN users.learned_concepts IS 'JSON array of web development concepts the user has learned (e.g., ["CSS Flexbox", "Alpine.js x-data", "Tailwind responsive"])';