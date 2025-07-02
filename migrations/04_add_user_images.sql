-- Migration: Add user_images table for database-stored images
-- This allows users to upload images and have them stored securely in the database

CREATE TABLE user_images (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    website_id INTEGER REFERENCES websites(id) ON DELETE CASCADE,
    
    -- Image metadata
    original_name VARCHAR(255) NOT NULL,
    mime_type VARCHAR(50) NOT NULL,
    file_size INTEGER NOT NULL,
    width INTEGER,
    height INTEGER,
    alt_text TEXT,
    
    -- Binary data storage
    image_data BYTEA NOT NULL,
    thumbnail_data BYTEA,
    
    -- Timestamps
    uploaded_at TIMESTAMP DEFAULT NOW(),
    last_used_at TIMESTAMP
);

-- Indexes for performance
CREATE INDEX idx_user_images_user_id ON user_images(user_id);
CREATE INDEX idx_user_images_website_id ON user_images(website_id);
CREATE INDEX idx_user_images_uploaded_at ON user_images(uploaded_at);

-- Add image tracking to existing tables
ALTER TABLE users ADD COLUMN image_count INTEGER DEFAULT 0;
ALTER TABLE websites ADD COLUMN has_images BOOLEAN DEFAULT FALSE;

-- Update existing users to have image_count = 0
UPDATE users SET image_count = 0 WHERE image_count IS NULL;
UPDATE websites SET has_images = FALSE WHERE has_images IS NULL;