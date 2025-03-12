import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/providers/order_items_provider.dart';

class OrderDetailsScreen extends ConsumerWidget {
  final String orderId;
  final double totalPrice;
  final String deliveryAddress;

  const OrderDetailsScreen({
    super.key,
    required this.orderId,
    required this.totalPrice,
    required this.deliveryAddress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderItemsAsync = ref.watch(orderItemsProvider(orderId));

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: Text("Order Details", style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            orderItemsAsync.when(
              data: (items) => items.isEmpty
                  ? _buildEmptyState()
                  : _buildOrderItemsList(items),
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child:
                    Text("Error: $error", style: TextStyle(color: Colors.red)),
              ),
            ),
            SizedBox(height: 20),
            _buildInfoCard(
                'Delivery Address', deliveryAddress, Icons.location_on),
            _buildInfoCard('Total Price', '₹${totalPrice.toStringAsFixed(2)}',
                Icons.monetization_on),
            _buildConfirmButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemsList(List items) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () {
            print('_buildOrderItemsList');
          },
          child: Card(
            color: Colors.grey[850],
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(item.imageUrl,
                    height: 70, width: 70, fit: BoxFit.cover),
              ),
              title: Text(item.name,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text(item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 5),
                  Text("₹${item.price.toStringAsFixed(2)}",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        "No order items found",
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.orangeAccent),
        title: Text(title,
            style:
                TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: TextStyle(color: Colors.white70)),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          backgroundColor: Colors.orange,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: () {},
        child: Text("Confirm Order",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
