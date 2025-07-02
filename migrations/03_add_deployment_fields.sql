-- Add deployment fields to websites table
-- Run after: init.sql

ALTER TABLE websites 
ADD COLUMN is_deployed BOOLEAN DEFAULT FALSE,
ADD COLUMN deployed_at TIMESTAMP,
ADD COLUMN custom_domain VARCHAR(255);

-- Create index for deployed websites
CREATE INDEX idx_websites_deployed ON websites(is_deployed, deployed_at);

-- Add comment explaining the fields
COMMENT ON COLUMN websites.is_deployed IS 'Whether the website is publicly accessible via subdomain';
COMMENT ON COLUMN websites.deployed_at IS 'Timestamp when the website was deployed';
COMMENT ON COLUMN websites.custom_domain IS 'Optional custom domain for premium users';