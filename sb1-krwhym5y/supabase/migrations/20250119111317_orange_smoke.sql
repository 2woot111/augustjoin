/*
  # Create and update database tables

  1. Tables
    - Create applications table with constraints
    - Create user_interactions table
    - Add indexes for performance
    - Enable RLS and policies

  2. Security
    - Enable RLS on all tables
    - Add policies for insert and select
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

  -- Add validation constraints
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

-- Create indexes if they don't exist
DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'applications_created_at_idx') THEN
    CREATE INDEX applications_created_at_idx ON applications (created_at);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'user_interactions_user_id_idx') THEN
    CREATE INDEX user_interactions_user_id_idx ON user_interactions (user_id);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'user_interactions_timestamp_idx') THEN
    CREATE INDEX user_interactions_timestamp_idx ON user_interactions (timestamp);
  END IF;
END $$;

-- Enable RLS
ALTER TABLE applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_interactions ENABLE ROW LEVEL SECURITY;

-- Create policies if they don't exist
DO $$ 
BEGIN
  -- Applications policies
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'applications' AND policyname = 'Anyone can insert applications'
  ) THEN
    CREATE POLICY "Anyone can insert applications"
      ON applications
      FOR INSERT
      TO anon
      WITH CHECK (true);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'applications' AND policyname = 'Anyone can read applications'
  ) THEN
    CREATE POLICY "Anyone can read applications"
      ON applications
      FOR SELECT
      TO anon
      USING (true);
  END IF;

  -- User interactions policies
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'user_interactions' AND policyname = 'Anyone can insert interactions'
  ) THEN
    CREATE POLICY "Anyone can insert interactions"
      ON user_interactions
      FOR INSERT
      TO anon
      WITH CHECK (true);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'user_interactions' AND policyname = 'Anyone can read interactions'
  ) THEN
    CREATE POLICY "Anyone can read interactions"
      ON user_interactions
      FOR SELECT
      TO anon
      USING (true);
  END IF;
END $$;