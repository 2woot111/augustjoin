import type { APIRoute } from 'astro';
import { supabase } from '../../lib/supabase';
import type { UserInteraction } from '../../lib/types';

export const POST: APIRoute = async ({ request }) => {
  try {
    const interaction: UserInteraction = await request.json();

    const { error } = await supabase
      .from('user_interactions')
      .insert([interaction]);

    if (error) throw error;

    return new Response(JSON.stringify({
      success: true
    }), { status: 200 });
  } catch (error) {
    console.error('Error tracking interaction:', error);
    return new Response(JSON.stringify({
      success: false,
      error: {
        message: 'Failed to track interaction',
        details: error instanceof Error ? error.message : 'Unknown error'
      }
    }), { status: 500 });
  }
}