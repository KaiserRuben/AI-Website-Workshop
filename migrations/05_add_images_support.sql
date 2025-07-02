-- Migration to add image support to the existing schema

-- Add has_images column to websites table
ALTER TABLE websites 
ADD COLUMN IF NOT EXISTS has_images BOOLEAN DEFAULT false;

-- Create user_images table
CREATE TABLE IF NOT EXISTS user_images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE NOT NULL,
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
    last_used_at TIMESTAMP,
    
    -- Indices
    CONSTRAINT user_images_user_id_idx FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT user_images_website_id_idx FOREIGN KEY (website_id) REFERENCES websites(id) ON DELETE CASCADE
);

-- Create indices for performance
CREATE INDEX IF NOT EXISTS idx_user_images_user ON user_images(user_id);
CREATE INDEX IF NOT EXISTS idx_user_images_website ON user_images(website_id);
CREATE INDEX IF NOT EXISTS idx_user_images_uploaded ON user_images(uploaded_at);

-- Add image_count to users table for tracking
ALTER TABLE users
ADD COLUMN IF NOT EXISTS image_count INTEGER DEFAULT 0;