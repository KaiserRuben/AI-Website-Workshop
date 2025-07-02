-- Add views_count field to websites table
-- Migration 09: Add views count tracking for public projects

ALTER TABLE websites 
ADD COLUMN views_count INTEGER DEFAULT 0 NOT NULL;