-- Migration to add project/collaboration features to existing schema
-- This is a minimal approach that extends the current website model

-- Add project-related columns to websites table
ALTER TABLE websites 
ADD COLUMN IF NOT EXISTS description TEXT,
ADD COLUMN IF NOT EXISTS slug VARCHAR(255),
ADD COLUMN IF NOT EXISTS is_public BOOLEAN DEFAULT false,
ADD COLUMN IF NOT EXISTS is_collaborative BOOLEAN DEFAULT false,
ADD COLUMN IF NOT EXISTS allow_comments BOOLEAN DEFAULT true,
ADD COLUMN IF NOT EXISTS allow_forks BOOLEAN DEFAULT true,
ADD COLUMN IF NOT EXISTS tags TEXT[] DEFAULT '{}',
ADD COLUMN IF NOT EXISTS parent_website_id INTEGER REFERENCES websites(id);

-- Create unique constraint for user + slug
ALTER TABLE websites ADD CONSTRAINT unique_user_slug UNIQUE (user_id, slug);

-- Simple collaborators table
CREATE TABLE IF NOT EXISTS website_collaborators (
    id SERIAL PRIMARY KEY,
    website_id INTEGER REFERENCES websites(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    can_edit BOOLEAN DEFAULT false,
    can_comment BOOLEAN DEFAULT true,
    invited_at TIMESTAMP DEFAULT NOW(),
    accepted_at TIMESTAMP,
    UNIQUE(website_id, user_id)
);

-- Comments table for projects
CREATE TABLE IF NOT EXISTS website_comments (
    id SERIAL PRIMARY KEY,
    website_id INTEGER REFERENCES websites(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    parent_comment_id INTEGER REFERENCES website_comments(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Share links table
CREATE TABLE IF NOT EXISTS website_shares (
    id SERIAL PRIMARY KEY,
    website_id INTEGER REFERENCES websites(id) ON DELETE CASCADE,
    share_token VARCHAR(255) UNIQUE DEFAULT gen_random_uuid()::text,
    created_by INTEGER REFERENCES users(id),
    can_edit BOOLEAN DEFAULT false,
    expires_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Create indices
CREATE INDEX IF NOT EXISTS idx_websites_slug ON websites(slug);
CREATE INDEX IF NOT EXISTS idx_websites_public ON websites(is_public) WHERE is_public = true;
CREATE INDEX IF NOT EXISTS idx_website_collaborators_user ON website_collaborators(user_id);
CREATE INDEX IF NOT EXISTS idx_website_collaborators_website ON website_collaborators(website_id);
CREATE INDEX IF NOT EXISTS idx_website_comments_website ON website_comments(website_id);
CREATE INDEX IF NOT EXISTS idx_website_shares_token ON website_shares(share_token);

-- Drop and recreate active_sessions view with project information
DROP VIEW IF EXISTS active_sessions;

CREATE VIEW active_sessions AS
SELECT 
    u.id as user_id,
    u.username,
    u.display_name,
    w.id as website_id,
    w.name as website_name,
    w.slug,
    w.description,
    w.is_public,
    w.html,
    w.css,
    w.js,
    w.tags,
    w.updated_at,
    COUNT(DISTINCT wl.id) as like_count,
    COUNT(DISTINCT wc.id) as comment_count,
    EXISTS(SELECT 1 FROM websites w2 WHERE w2.parent_website_id = w.id) as has_forks
FROM users u
JOIN websites w ON u.id = w.user_id
LEFT JOIN website_likes wl ON w.id = wl.website_id
LEFT JOIN website_comments wc ON w.id = wc.website_id
WHERE w.is_active = true
AND u.last_seen > NOW() - INTERVAL '5 minutes'
GROUP BY u.id, w.id
ORDER BY w.updated_at DESC;

-- Function to generate unique slugs
CREATE OR REPLACE FUNCTION generate_unique_slug(base_slug TEXT, user_id INTEGER)
RETURNS TEXT AS $$
DECLARE
    new_slug TEXT;
    counter INTEGER := 0;
BEGIN
    new_slug := base_slug;
    WHILE EXISTS(SELECT 1 FROM websites WHERE slug = new_slug AND websites.user_id = generate_unique_slug.user_id) LOOP
        counter := counter + 1;
        new_slug := base_slug || '-' || counter;
    END LOOP;
    RETURN new_slug;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-generate slug from website name
CREATE OR REPLACE FUNCTION generate_website_slug()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.slug IS NULL OR NEW.slug = '' THEN
        NEW.slug := generate_unique_slug(
            lower(regexp_replace(NEW.name, '[^a-zA-Z0-9]+', '-', 'g')),
            NEW.user_id
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER website_slug_trigger
BEFORE INSERT OR UPDATE ON websites
FOR EACH ROW
EXECUTE FUNCTION generate_website_slug();