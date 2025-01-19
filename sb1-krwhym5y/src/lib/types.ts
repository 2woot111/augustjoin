export interface ApplicationData {
  is_undergraduate: boolean;
  current_year?: number;
  major?: string;
  can_access_student_list: boolean;
  student_list_confidence?: number;
  has_admissions_contact: boolean;
  admissions_contact_confidence?: number;
  response_speed: number;
}

export interface ApiResponse {
  success: boolean;
  meetsRequirements?: boolean;
  error?: {
    message: string;
    details?: string;
    stack?: string;
  };
}

export interface UserInteraction {
  user_id: string;
  timestamp: string;
  action: string;
  section?: string;
  time_spent?: number;
  completed?: boolean;
}