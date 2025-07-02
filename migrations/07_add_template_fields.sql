-- Add new fields to templates table
ALTER TABLE templates 
ADD COLUMN order_index INTEGER DEFAULT 0,
ADD COLUMN template_metadata JSON;

-- Clear existing template data to avoid conflicts
DELETE FROM templates;