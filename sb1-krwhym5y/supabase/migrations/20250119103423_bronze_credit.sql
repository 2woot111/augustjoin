/*
  # Create user interactions tracking table

  1. New Tables
    - `user_interactions`
      - `id` (uuid, primary key)
      - `user_id` (text, required) - Unique identifier for the user session
      - `timestamp` (timestamptz, required) - When the interaction occurred
      - `action` (text, required) - Type of interaction (e.g., apply_start, section_complete)
      - `section` (text) - Form section identifier if applicable
      - `time_spent` (integer) - Time spent in milliseconds if applicable
      - `completed` (boolean) - Whether a section was completed
      - `created_at` (timestamptz) - Record creation timestamp
  
  2. Security
    - Enable RLS on `user_interactions` table
    - Add policy for anonymous users to insert interactions
    - Add policy for reading own interactions
*/

CREATE TABLE IF NOT EXISTS user_interactions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id text NOT NULL,
  timestamp timestamptz NOT NULL,
  action text NOT NULL,
  section text,
  time_spent integer,
  completed boolean,
  created_at timestamptz DEFAULT now()
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS user_interactions_user_id_idx ON user_interactions (user_id);
CREATE INDEX IF NOT EXISTS user_interactions_timestamp_idx ON user_interactions (timestamp);

-- Enable RLS
ALTER TABLE user_interactions ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Anyone can insert interactions"
  ON user_interactions
  FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "Users can read own interactions"
  ON user_interactions
  FOR SELECT
  TO anon
  USING (true);