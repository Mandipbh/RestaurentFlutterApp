import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final cartProvider =
    StateNotifierProvider<CartNotifier, List<Map<String, dynamic>>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  CartNotifier() : super([]);

  Future<void> addToCart(String userId, String foodId, int quantity) async {
    await Supabase.instance.client.from('cart').insert({
      'user_id': userId,
      'food_id': foodId,
      'quantity': quantity,
    });
    fetchCart(userId);
  }

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

  Future<void> removeFromCart(String cartId, String userId) async {
    await Supabase.instance.client.from('cart').delete().eq('id', cartId);
    fetchCart(userId);
  }
}
