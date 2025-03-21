import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:supabase_flutter/supabase_flutter.dart";

final cartProvider =
    StateNotifierProvider<CartNotifier, List<Map<String, dynamic>>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  CartNotifier() : super([]);

  Future<void> addToCart(
    BuildContext context,
    String userId, {
    String? foodId, 
    String? combinationBreakfastId, 
    String? recommendedBreakfastId,
    String? allFoodId, 
    int quantity = 1,
    required String restaurentId, // Ensure restaurant ID is required
  }) async {
    if (foodId == null &&
        combinationBreakfastId == null &&
        recommendedBreakfastId == null &&
        allFoodId == null) {
      throw ArgumentError(
          'Either foodId, combinationBreakfastId, recommendedBreakfastId, or allFoodId must be provided.');
    }

    // Fetch current cart items
    final cartItems = await Supabase.instance.client
        .from('cart')
        .select('restaurent_id')
        .eq('user_id', userId);

    // Check if the cart contains items from a different restaurant
    if (cartItems.isNotEmpty && cartItems[0]['restaurent_id'] != restaurentId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Cannot add items from different restaurant. Clear the cart first."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }else{
            ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Added to Cart 🛒"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }

    await Supabase.instance.client.from('cart').insert({
      'user_id': userId,
      if (foodId != null) 'food_id': foodId,
      if (combinationBreakfastId != null)
        'combination_breakfast_id': combinationBreakfastId,
      if (recommendedBreakfastId != null)
        'recommended_breakfast_id': recommendedBreakfastId,
      if (allFoodId != null) 'all_food_id': allFoodId,
      'quantity': quantity,
      'restaurent_id': restaurentId, // Ensure restaurant ID is stored
    });

    fetchCart(userId);
  }

  Future<void> fetchCart(String userId) async {
    try {
   final response = await Supabase.instance.client
       .from('cart')
       .select('''
         *,
         food_items:food_items!cart_food_fk(*),
         all_foods!left(*),
         combination_breakfast!left(*),
         recommended_breakfast!left(*)
       ''')
       .eq('user_id', userId);

      print("✅ Supabase Response: $response");

      state = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("❌ Exception in fetchCart: $e");
    }
  }

  Future<void> updateQuantity(
      String itemId, String userId, int newQuantity) async {
    if (newQuantity <= 0) return removeFromCart(itemId, userId);

    try {
      await Supabase.instance.client
          .from('cart')
          .update({'quantity': newQuantity}).eq('id', itemId);

      // Update local state immediately for responsive UI
      state = state.map((item) {
        if (item['id'] == itemId) {
          return {...item, 'quantity': newQuantity};
        }
        return item;
      }).toList();

      // Optionally refresh from server to ensure consistency
      await fetchCart(userId);
    } catch (e) {
      print("❌ Exception in updateQuantity: $e");
    }
  }

  Future<void> removeFromCart(String itemId, String userId) async {
    try {
      await Supabase.instance.client.from("cart").delete().eq("id", itemId);

      state = state.where((item) => item["id"] != itemId).toList();
      await fetchCart(userId);
    } catch (e) {
      print("❌ Exception in removeFromCart: $e");
    }
  }

  Future<void> clearCart(String userId) async {
    final supabase = Supabase.instance.client;

    try {
      await supabase.from("cart").delete().eq("user_id", userId);
      state = [];
      print("Cart cleared successfully");

      await fetchCart(userId);
    } catch (e) {
      print("❌ Error clearing cart: $e");
    }
  }
}