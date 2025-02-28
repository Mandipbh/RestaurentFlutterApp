import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:supabase_flutter/supabase_flutter.dart";

final cartProvider =
    StateNotifierProvider<CartNotifier, List<Map<String, dynamic>>>((ref)
{
  return CartNotifier();
}
);

class CartNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  CartNotifier(): super
  ([]);
















Future<void> addToCart(
  String userId, {
  String? foodId,  // Keep it as String since it's a UUID
  String? combinationBreakfastId,  // UUIDs are Strings
  String? recommendedBreakfastId,  // UUIDs are Strings
  int quantity = 1,
}) async {
  if (foodId == null && combinationBreakfastId == null && recommendedBreakfastId == null) {
    throw ArgumentError('Either foodId, combinationBreakfastId, or recommendedBreakfastId must be provided.');
  }

  await Supabase.instance.client.from('cart').insert({
    'user_id': userId,
    if (foodId != null) 'food_id': foodId,
    if (combinationBreakfastId != null) 'combination_breakfast_id': combinationBreakfastId,
    if (recommendedBreakfastId != null) 'recommended_breakfast_id': recommendedBreakfastId,
    'quantity': quantity,
  });

  fetchCart(userId);
}







  Future<void>
  fetchCart(String userId)
  async {
    try {
      final response = await Supabase.instance.client
          .from('cart')
          .select('*, food_items!left(*), combination_breakfast!left(*), recommended_breakfast!left(*)')
          .eq('user_id', userId);

      print("✅ Supabase Response: $response");

      state = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("❌ Exception in fetchCart: $e");
    }
  }

  Future<void>
  updateQuantity(
      String itemId, String userId, int newQuantity)
  async {
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
    }
  catch(e) {
    print("❌ Exception in updateQuantity: $e");
  }
}

Future<void> removeFromCart(String itemId, String userId)
async
{
  try {
    // Remove from Supabase
    await Supabase.instance.client.from("cart").delete().eq("id", itemId);

    // Update local state
    state = state.where((item) => item["id"] != itemId).toList();

    // Optionally refresh from server
    await fetchCart(userId);
  } catch (e) {
    print("❌ Exception in removeFromCart: $e");
  }
}

Future<void> clearCart(String userId)
async
{
  final
  supabase = Supabase.instance.client;

  try {
    await supabase.from("cart").delete().eq("user_id", userId) ;
    state = [] ;
    print("Cart cleared successfully");

    // Fetch the updated cart items
    await fetchCart(userId);
  } catch (e) {
    print("❌ Error clearing cart: $e");
  }
}

}

