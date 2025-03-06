import 'package:flutter/material.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/model/order_item_modeld.dart';
import 'package:restaurent/services/order_service.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late Future<List<OrderItemModel>> orderItemsFuture;

  @override
  void initState() {
    super.initState();
    orderItemsFuture = OrderService().fetchOrderItems(widget.orderId);
  }

 
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
    body: FutureBuilder<List<OrderItemModel>>(
      future: orderItemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No order items found"));
        }

        final items = snapshot.data!;
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              color: Colors.grey[900],
              margin: EdgeInsets.all(8),
              child: ListTile(
                title: Text(item.name, style: TextStyle(color: Colors.white)),
                subtitle: Text("Qty: ${item.quantity}", style: TextStyle(color: Colors.grey)),
                trailing: Text("\$${item.price}", style: TextStyle(color: Colors.greenAccent)),
              ),
            );
          },
        );
      },
    ),
  );
}
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
}