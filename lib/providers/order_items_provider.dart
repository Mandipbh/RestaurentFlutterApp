import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/model/order_item_modeld.dart';
import 'package:restaurent/services/order_service.dart';



final orderItemsProvider = FutureProvider.family<List<OrderItemModel>, String>(
  (ref, orderId) async {
    return OrderService().fetchOrderItems(orderId);
  },
);