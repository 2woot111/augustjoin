/*
  # Create applications table with proper structure

  1. New Tables
    - `applications`
      - `id` (uuid, primary key)
      - `is_undergraduate` (boolean)
      - `current_year` (integer)
      - `major` (text)
      - `can_access_student_list` (boolean)
      - `student_list_confidence` (integer)
      - `has_admissions_contact` (boolean)
      - `admissions_contact_confidence` (integer)
      - `response_speed` (integer)
      - `created_at` (timestamptz)

  2. Security
    - Enable RLS on `applications` table
    - Add policies for inserting and reading applications
*/

-- Drop existing table if it exists
DROP TABLE IF EXISTS applications;

-- Create applications table
CREATE TABLE applications (
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

-- Create index for faster queries
CREATE INDEX applications_created_at_idx ON applications (created_at);

-- Enable Row Level Security
ALTER TABLE applications ENABLE ROW LEVEL SECURITY;

-- Create policies
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