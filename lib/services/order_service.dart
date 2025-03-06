import 'package:restaurent/model/order_item_modeld.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderService {
  final supabase = Supabase.instance.client;

  Future<List<OrderItemModel>> fetchOrderItems(String orderId) async {
    try {
      // Step 1: Fetch order_items based on order_id
      final orderItemsResponse = await supabase
          .from('order_items')
          .select('*')
          .eq('order_id', orderId);

      if (orderItemsResponse.isEmpty) return [];

      List<OrderItemModel> orderItems = [];

      // Step 2: Fetch all_foods based on IDs from order_items
      for (var item in orderItemsResponse) {
        String? foodId = item['food_id'];
        String? recommendedId = item['recommended_breakfast_id'];
        String? combinationId = item['combination_breakfast_id'];

        // Find food details in all_foods
        final foodResponse = await supabase
            .from('all_foods')
            .select('*')
            .or([
              if (foodId != null) "id.eq.$foodId",
              if (recommendedId != null) "id.eq.$recommendedId",
              if (combinationId != null) "id.eq.$combinationId"
            ].join(','));

        String foodName = "Unknown";
        double price = 0.0;

        if (foodResponse.isNotEmpty) {
          var foodData = foodResponse.first;
          foodName = foodData['name'] ?? "Unknown";
          price = (foodData['price'] as num).toDouble();
        }

        orderItems.add(OrderItemModel(
          id: item['id'],
          orderId: item['order_id'],
          foodId: foodId,
          recommendedId: recommendedId,
          combinationId: combinationId,
          name: foodName,
          quantity: item['quantity'],
          price: price,
        ));
      }

      return orderItems;
    } catch (e) {
      throw Exception("Error fetching order items: $e");
    }
  }
}