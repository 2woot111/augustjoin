import type { ApplicationData } from './types';

export class ValidationError extends Error {
  constructor(message: string, public details?: string) {
    super(message);
    this.name = 'ValidationError';
  }
}

export function validateApplication(data: ApplicationData): void {
  // Required fields
  if (data.is_undergraduate === undefined) {
    throw new ValidationError('Undergraduate status is required');
  }

  if (data.can_access_student_list === undefined) {
    throw new ValidationError('Student list access status is required');
  }

  if (data.has_admissions_contact === undefined) {
    throw new ValidationError('Admissions contact status is required');
  }

  if (data.response_speed === undefined) {
    throw new ValidationError('Response speed is required');
  }

  // Conditional required fields
  if (data.is_undergraduate) {
    if (!data.current_year) {
      throw new ValidationError('Current year is required for undergraduates');
    }
    if (!data.major) {
      throw new ValidationError('Major is required for undergraduates');
    }
  }

  // Confidence ratings validation
  if (data.can_access_student_list && !data.student_list_confidence) {
    throw new ValidationError('Student list confidence rating is required');
  }

  if (data.has_admissions_contact && !data.admissions_contact_confidence) {
    throw new ValidationError('Admissions contact confidence rating is required');
  }

  // Range validations
  if (data.current_year && (data.current_year < 2025 || data.current_year > 2028)) {
    throw new ValidationError('Invalid graduation year', 'Year must be between 2025 and 2028');
  }

  if (data.student_list_confidence && (data.student_list_confidence < 1 || data.student_list_confidence > 10)) {
    throw new ValidationError('Invalid student list confidence rating', 'Rating must be between 1 and 10');
  }

  if (data.admissions_contact_confidence && (data.admissions_contact_confidence < 1 || data.admissions_contact_confidence > 10)) {
    throw new ValidationError('Invalid admissions contact confidence rating', 'Rating must be between 1 and 10');
  }

  if (data.response_speed < 1 || data.response_speed > 10) {
    throw new ValidationError('Invalid response speed rating', 'Rating must be between 1 and 10');
  }
}