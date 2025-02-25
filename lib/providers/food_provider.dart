import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

final foodListProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>(
        (ref, categoryId) async {
  try {
    final response = await supabase
        .from('food_items')
        .select()
        .eq('category_id', categoryId);
    return response.cast<Map<String, dynamic>>();
  } catch (e) {
    throw Exception('Failed to load food items: $e');
  }
});

final foodReviewsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, Map<String, String>>(
  (ref, params) async {
    try {
      final String foodId = params['food_id']?.toString() ?? '';
      final String userId = params['user_id']?.toString() ?? '';

      final response = await supabase
          .from('food_reviews')
          .select('*')
          .eq('food_id', foodId)
          .eq('user_id', userId);
      print('Fetched Reviews: $response'); // Debugging

      final response1 = await supabase.from('food_reviews').select('*');
      print('All Reviews: $response1');

      return response.cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to load reviews: $e');
    }
  },
);
