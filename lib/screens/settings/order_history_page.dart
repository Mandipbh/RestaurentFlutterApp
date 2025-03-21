import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/providers/order_provider.dart';
import 'package:restaurent/services/order_items.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Order History", style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer(
          builder: (context, ref, child) {
            final orderData = ref.watch(orderProvider);
            return orderData.when(
              data: (orders) {
                return Column(
                  children: [
                    Expanded(
                      child: orders.isEmpty
                          ? Center(
                              child: Text(
                                "No Orders Found",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 16),
                              ),
                            )
                          : ListView.builder(
                              itemCount: orders.length,
                              itemBuilder: (context, index) {
                                final orderItem = orders[index];
                                return _buildOrderCard(orderItem, context);
                              },
                            ),
                    ),
                  ],
                );
              },
              loading: () => Center(child: CircularProgressIndicator(color: Colors.orange,)),
              error: (err, _) => Center(
                child: Text("Error: $err", style: TextStyle(color: Colors.red)),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderCard(order, BuildContext context) {
    String formattedDate = _formatDate(order.createdAt);

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderDetailsScreen(
                    orderId: order.id,
                    totalPrice: order.totalPrice,
                    deliveryAddress: order.deliveryAdress)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "#${order.id}",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  "₹${order.totalPrice.toStringAsFixed(2)}",
                  style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusChip(order.status),
                Text(
                  formattedDate,
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(color: Colors.white10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildActionButton(
                    Icons.local_shipping, "Track", Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      return "Invalid Date";
    }
  }

  Widget _buildStatusChip(String status) {
    Color statusColor = Colors.blue;
    if (status == "Delivered") statusColor = Colors.green;
    if (status == "Cancelled") statusColor = Colors.red;
    if (status == "Pending") statusColor = Colors.orange;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
            color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return TextButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: color, size: 18),
      label: Text(label, style: TextStyle(color: color)),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        backgroundColor: color.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
