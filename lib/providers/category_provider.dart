import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final catListProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final response = await Supabase.instance.client.from('categories').select();
  
  if (response is List) {
    return response.cast<Map<String, dynamic>>();
  } else {
    throw Exception("Invalid data format from Supabase");
  }
});

// Initialize with a default category ID for "Frequent Order"
final selectedCategoryIdProvider = StateProvider<String>((ref) => '28e74c6b-a795-495c-89ed-ba0149a0484e');
