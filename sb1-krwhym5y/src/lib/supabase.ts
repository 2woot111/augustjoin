import { createClient } from '@supabase/supabase-js';

// For local development and testing
const supabaseUrl = 'https://ufglnqvopnniuolyupye.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVmZ2xucXZvcG5uaXVvbHl1cHllIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzcyNzc1MDMsImV4cCI6MjA1Mjg1MzUwM30.egGkbiHiY6CIV0Ahrdehphi-f3IPTAsWgJm-Ht2PJXU';

export const supabase = createClient(supabaseUrl, supabaseKey);