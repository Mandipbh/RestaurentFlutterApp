import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/providers/order_items_provider.dart';
import 'package:restaurent/screens/cart/widgets/location_display.dart';
import 'package:restaurent/widgets/custom_text.dart';

class OrderDetailsScreen extends ConsumerWidget {
  final String orderId;
  final double totalPrice;
  final String deliveryAddress;
  const OrderDetailsScreen({super.key, required this.orderId, required this.totalPrice , required this.deliveryAddress});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderItemsAsync = ref.watch(orderItemsProvider(orderId));

    print("response of orderItemAsync >> $orderItemsAsync");



    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Order Details", style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          orderItemsAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return Center(child: Text("No order items found", style: TextStyle(color: Colors.white)));
              }
              return SizedBox(
                height: 400,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      color: Colors.grey[900],
                      margin: EdgeInsets.all(8),
                      child:  Card(
                            color: Colors.grey.shade900, 
                            margin: EdgeInsets.all(10),
                            child: Row(
                children: [
                      Image.network(item.imageUrl, height: 100, width: 100, fit: BoxFit.cover),
                            
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                            
                            
                    children: [
                      Text(item.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 5),
                            
                      SizedBox(
                            width: 250, // Set a fixed width
                            child: Text(
                item.description,
                style: TextStyle(color: Colors.white70),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                            ),
                            ),
                            
                            
                            
                            
                            
                    SizedBox(height: 5),
                      Text("₹ ${item.price.toStringAsFixed(2)}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: 
                          Colors.green)),
                    ],
                  ),
                ),
                            ],
                          ),
                ],
                            ),
                          ),
                        
                      
                    
                          
                          
                          
                          
                          
                    
                    
                    
                    );
                  },
                ),
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text("Error: $error", style: TextStyle(color: Colors.red))),
          ),
                    SizedBox(height: 30),

          CustomText(text: 'Delivery Address', fontSize: 20, color: Colors.orange, fontWeight: FontWeight.bold,),
        
         Card(
                       color: Colors.grey.shade900, 
 margin: EdgeInsets.all(10),

           child: Padding(
             padding: const EdgeInsets.all(8.0),
             child: LocationDisplay(
               location:deliveryAddress,
               onEdit: (){},
             ),
           ),
         ),

          Card(
            
             color: Colors.grey.shade900, 
 margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: CustomText(text: 'Total Price : ₹$totalPrice', fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold,),
            )),

        ],
      ),
    );
  }
}