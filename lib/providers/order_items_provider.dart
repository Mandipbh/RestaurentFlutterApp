import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/model/all_food_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final orderItemsProvider = FutureProvider.family<List<AllFood>, String>((ref, orderId) async {
  final supabase = Supabase.instance.client;

  try {
    // Fetch order items for given order_id
    final orderItemsResponse = await supabase
        .from('order_items')
        .select('food_id, recommended_breakfast_id, combination_breakfast_id')
        .eq('order_id', orderId);

    if (orderItemsResponse.isEmpty) return [];

    // Collect all IDs into a list
    List<String> allIds = [];
    for (var item in orderItemsResponse) {
      if (item['food_id'] != null) allIds.add(item['food_id'].toString());
      if (item['recommended_breakfast_id'] != null) allIds.add(item['recommended_breakfast_id'].toString());
      if (item['combination_breakfast_id'] != null) allIds.add(item['combination_breakfast_id'].toString());
    }

    if (allIds.isEmpty) return [];

    // 🔥 FIX: Use `or` instead of `.in_()`
    final foodResponse = await supabase
        .from('all_foods')
        .select('*')
        .or([
          for (var id in allIds) "original_id.eq.$id"
        ].join(','));

  
  
      List<AllFood> orderItems = foodResponse.map<AllFood>((food) => AllFood.fromJson(food)).toList();
  
  
  
  
  

    return orderItems;
  } catch (e) {
    throw Exception("Error fetching order items: $e");
  }
});
































