import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final cartProvider =
    StateNotifierProvider<CartNotifier, List<Map<String, dynamic>>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  CartNotifier() : super([]);

  /// Add item to cart
  Future<void> addToCart(String userId, String foodId, int quantity) async {
    await Supabase.instance.client.from('cart').insert({
      'user_id': userId,
      'food_id': foodId,
      'quantity': quantity,
    });
    fetchCart(userId);
  }

  /// Fetch cart items from Supabase
  Future<void> fetchCart(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('cart')
          .select('*, food_items(*)')
          .eq('user_id', userId);

      print("✅ Supabase Response: $response");

      state = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("❌ Exception in fetchCart: $e");
    }
  }

  Future<void> updateQuantity(String itemId, String userId, int newQuantity) async {
    if (newQuantity <= 0) return removeFromCart(itemId, userId);

    try {
      await Supabase.instance.client
          .from('cart')
          .update({'quantity': newQuantity})
          .eq('id', itemId);

      state = state.map((item) {
        if (item['id'] == itemId) {
          return {...item, 'quantity': newQuantity};
        }
        return item;
      }).toList();
    } catch (e) {
      print("❌ Exception in updateQuantity: $e");
    }
  }

  Future<void> removeFromCart(String itemId, String userId) async {
    try {
      // Remove from Supabase
      await Supabase.instance.client
          .from('cart')
          .delete()
          .eq('id', itemId);

      // Update local state
      state = state.where((item) => item['id'] != itemId).toList();
    } catch (e) {
      print("❌ Exception in removeFromCart: $e");
    }
  }
}