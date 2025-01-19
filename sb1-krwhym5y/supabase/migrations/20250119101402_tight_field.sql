/*
  # Update Applications Schema

  1. Table Structure
    - `applications`
      - `id` (uuid, primary key): Unique identifier
      - `is_undergraduate` (boolean): Current undergraduate status
      - `current_year` (integer): Graduation year (2025-2028)
      - `major` (text): Student's major
      - `can_access_student_list` (boolean): Access to student list
      - `student_list_confidence` (integer): Confidence rating (1-10)
      - `has_admissions_contact` (boolean): Access to admissions contact
      - `admissions_contact_confidence` (integer): Confidence rating (1-10)
      - `response_speed` (integer): Response speed rating (1-10)
      - `created_at` (timestamptz): Record creation timestamp

  2. Changes
    - Add validation constraints for all fields
    - Create index for performance optimization
*/

-- Create applications table with all required fields and constraints
DO $$ BEGIN
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
EXCEPTION
  WHEN duplicate_table THEN
    NULL;
END $$;

-- Create index for faster queries if it doesn't exist
DO $$ BEGIN
  CREATE INDEX IF NOT EXISTS applications_created_at_idx ON applications (created_at);
EXCEPTION
  WHEN duplicate_object THEN
    NULL;
END $$;