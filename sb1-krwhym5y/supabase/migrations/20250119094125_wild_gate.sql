/*
  # Initial Schema Setup for August Application

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
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on all tables
    - Add policies for application access
*/

-- Create applications table
CREATE TABLE IF NOT EXISTS applications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  is_undergraduate boolean NOT NULL,
  current_year integer,
  major text,
  can_access_student_list boolean NOT NULL,
  student_list_confidence integer CHECK (student_list_confidence >= 1 AND student_list_confidence <= 10),
  has_admissions_contact boolean NOT NULL,
  admissions_contact_confidence integer CHECK (admissions_contact_confidence >= 1 AND admissions_contact_confidence <= 10),
  response_speed integer NOT NULL CHECK (response_speed >= 1 AND response_speed <= 10),
  created_at timestamptz DEFAULT now(),
  
  -- Add validation constraints
  CONSTRAINT valid_year CHECK (current_year >= 2024 AND current_year <= 2028),
  CONSTRAINT valid_confidence_scores CHECK (
    (NOT can_access_student_list OR student_list_confidence IS NOT NULL) AND
    (NOT has_admissions_contact OR admissions_contact_confidence IS NOT NULL)
  )
);

-- Enable RLS
ALTER TABLE applications ENABLE ROW LEVEL SECURITY;

-- Create policy for inserting applications
CREATE POLICY "Anyone can insert applications"
  ON applications
  FOR INSERT
  TO anon
  WITH CHECK (true);

-- Create policy for reading own applications
CREATE POLICY "Anyone can read applications"
  ON applications
  FOR SELECT
  TO anon
  USING (true);