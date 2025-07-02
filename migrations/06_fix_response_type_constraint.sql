-- Fix llm_calls response_type constraint to allow both lowercase and uppercase
-- This handles the case where response_type might be 'UPDATE_ALL' instead of 'update_all'

-- Drop the existing constraint
ALTER TABLE llm_calls DROP CONSTRAINT IF EXISTS llm_calls_response_type_check;

-- Add new constraint that accepts both formats
ALTER TABLE llm_calls ADD CONSTRAINT llm_calls_response_type_check 
CHECK (response_type IN ('chat', 'update', 'update_all', 'rewrite', 'UPDATE_ALL', 'CHAT', 'UPDATE', 'REWRITE'));