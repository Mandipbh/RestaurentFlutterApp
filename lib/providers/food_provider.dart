import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final foodListProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, categoryId) async {
  try {
    final response = await Supabase.instance.client
        .from('food_items')
        .select()
        .eq('category_id', categoryId);
    
    if (response is List) {
      return response.cast<Map<String, dynamic>>();
    }
    return [];
  } catch (e) {
    throw Exception('Failed to load food items: $e');
  }
});

