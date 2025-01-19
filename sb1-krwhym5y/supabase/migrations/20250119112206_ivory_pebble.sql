/*
  # Database Schema Setup

  1. Tables
    - applications: Stores application form submissions
    - user_interactions: Tracks user behavior and form progress
  
  2. Indexes
    - Optimized queries for created_at, user_id, and timestamp fields
  
  3. Security
    - Row Level Security (RLS) enabled
    - Policies for insert and select operations
*/

-- Create applications table if it doesn't exist
CREATE TABLE IF NOT EXISTS applications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  is_undergraduate boolean NOT NULL,
  current_year integer CHECK (current_year >= 2025 AND current_year <= 2028),
  major text,
  can_access_student_list boolean NOT NULL,
  student_list_confidence integer CHECK (student_list_confidence >= 1 AND student_list_confidence <= 10),
  has_admissions_contact boolean NOT NULL,
  admissions_contact_confidence integer CHECK (admissions_contact_confidence >= 1 AND admissions_contact_confidence <= 10),
  response_speed integer NOT NULL CHECK (response_speed >= 1 AND response_speed <= 10),
  created_at timestamptz DEFAULT now(),

  CONSTRAINT valid_undergraduate_data CHECK (
    (NOT is_undergraduate OR (current_year IS NOT NULL AND major IS NOT NULL))
  ),
  CONSTRAINT valid_student_list_confidence CHECK (
    (NOT can_access_student_list OR student_list_confidence IS NOT NULL)
  ),
  CONSTRAINT valid_admissions_confidence CHECK (
    (NOT has_admissions_contact OR admissions_contact_confidence IS NOT NULL)
  )
);

-- Create user interactions table if it doesn't exist
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

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS applications_created_at_idx ON applications (created_at);
CREATE INDEX IF NOT EXISTS user_interactions_user_id_idx ON user_interactions (user_id);
CREATE INDEX IF NOT EXISTS user_interactions_timestamp_idx ON user_interactions (timestamp);

-- Enable Row Level Security
ALTER TABLE applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_interactions ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Anyone can insert applications" ON applications;
DROP POLICY IF EXISTS "Anyone can read applications" ON applications;
DROP POLICY IF EXISTS "Anyone can insert interactions" ON user_interactions;
DROP POLICY IF EXISTS "Anyone can read interactions" ON user_interactions;

-- Create policies for applications table
CREATE POLICY "Anyone can insert applications"
  ON applications
  FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "Anyone can read applications"
  ON applications
  FOR SELECT
  TO anon
  USING (true);

-- Create policies for user interactions table
CREATE POLICY "Anyone can insert interactions"
  ON user_interactions
  FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "Anyone can read interactions"
  ON user_interactions
  FOR SELECT
  TO anon
  USING (true);