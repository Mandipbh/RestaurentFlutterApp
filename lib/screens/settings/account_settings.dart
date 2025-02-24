import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/constants/images.dart';
import 'package:restaurent/model/user_model.dart';
import 'package:restaurent/providers/order_provider.dart';
import 'package:restaurent/providers/payment_provider.dart';
import 'package:restaurent/providers/user_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool isAddressExpanded = false;
  bool isOrderHistoryExpanded = false;
  bool isPaymentsExpanded = false;

  
  
  

  
  @override
Widget build(BuildContext context) {
  final user = ref.watch(userProvider);

  if (user == null) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  return Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.black,
    ),
    body: SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(Images.circleavatar_bg),
          ),
          SizedBox(height: 10),
          Text(
            user.fullName ?? "Unknown",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            user.phone ?? "No phone available",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          Text(
            user.email ?? "No email available",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          SizedBox(height: 10),
          buildExpandableCard("Address", isAddressExpanded, () {
            setState(() {
              isAddressExpanded = !isAddressExpanded;
            });
          }, isAddressExpanded ? buildAddressDetails(user) : null),
          SizedBox(height: 10),
          buildExpandableCard("Order history", isOrderHistoryExpanded, () {
            setState(() {
              isOrderHistoryExpanded = !isOrderHistoryExpanded;
            });
          }, isOrderHistoryExpanded ? buildOrderHistoryDetails() : null),
          SizedBox(height: 10),
          buildExpandableCard(
            "Payments",
            isPaymentsExpanded,
            () {
              setState(() {
                isPaymentsExpanded = !isPaymentsExpanded;
                if (isPaymentsExpanded) {
                  ref.refresh(paymentProvider);
                }
              });
            },
            isPaymentsExpanded ? buildPaymentDetails() : null,
          ),
        ],
      ),
    ),
  );
}
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  Widget buildExpandableCard(String title, bool isExpanded, VoidCallback onTap,
      Widget? expandedContent) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: isExpanded ? null : 0,
          child: expandedContent ?? SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget buildAddressDetails(UserModel user) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Home",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          Text(user.address, style: TextStyle(color: Colors.white70)),
    
    
    
        ],
      ),
    );
  }

   Widget buildOrderHistoryDetails() {
   return Consumer(
     builder: (context, ref, child) {
       final orderData = ref.watch(orderProvider);
       return orderData.when(
         data: (order) {
           if (order.isEmpty) {
             return Center(
                 child: Text("No Orders found",
                     style: TextStyle(color: Colors.white70)));
           }
           return Column(
             children: order.map((order) {
               return Card(
                 color: Colors.grey[850],
                 child: ListTile(
                   title: Text(
                     "₹${order.totalPrice.toStringAsFixed(2)} - ${order.id}",
                     style: TextStyle(color: Colors.white),
                   ),
                   subtitle: Text(
                     "Status: ${order.status} | ${order.createdAt}",
                     style: TextStyle(color: Colors.white70),
                   ),
                 ),
               );
             }).toList(),
           );
         },
         loading: () => Center(child: CircularProgressIndicator()),
         error: (err, _) => Center(
             child: Text("Error: $err", style: TextStyle(color: Colors.red))),
       );
     },
   );
 }

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  Widget buildPaymentDetails() {
    return Consumer(
      builder: (context, ref, child) {
        final paymentData = ref.watch(paymentProvider);

        return paymentData.when(
          data: (payments) {
            if (payments.isEmpty) {
              return Center(
                  child: Text("No payments found",
                      style: TextStyle(color: Colors.white70)));
            }

            return Column(
              children: payments.map((payment) {
                return Card(
                  color: Colors.grey[850],
                  child: ListTile(
                    title: Text(
                      "₹${payment.amount.toStringAsFixed(2)} - ${payment.method}",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "Status: ${payment.status} | ${payment.createdAt.toLocal()}",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                );
              }).toList(),
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
              child: Text("Error: $err", style: TextStyle(color: Colors.red))),
        );
      },
    );
  }
}
