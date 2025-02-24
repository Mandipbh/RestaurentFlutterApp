import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/providers/auth_provider.dart';
import 'package:restaurent/screens/cart/widgets/cart_item_list.dart';
import 'package:restaurent/screens/order_food/order_success.dart';
import 'package:restaurent/services/stripe_service.dart';
import 'package:restaurent/widgets/custom_text.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final double totalPrice;
  final String userAddress;
  final List<Map<String, dynamic>> cartItems;

  const PaymentScreen({
    super.key,
    required this.totalPrice,
    required this.userAddress,
    required this.cartItems,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  void _payWithCard() {
    StripeService.instance
        .makePayment(widget.totalPrice, widget.userAddress, widget.cartItems);
  }

  void _cashOnDelivery() {
    print("Cash on Delivery selected");
 Navigator.push(
   context,
   MaterialPageRoute(builder: (context) => OrderScreen()),
 );  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title:
            Text("Payment Options", style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: CartItemList(cartItems: widget.cartItems, userId: user!.id , isPayment:  true,)),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
  padding: EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: Colors.grey.shade900,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Column(
    children: [
      Text(
        'Total Price : ${widget.totalPrice}',
        style: TextStyle(color: Colors.white),
      )
    ],
  ),
),
            _paymentMethods(),
          ],
        ),
      ),
    );
  }

  

  Widget _paymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
  
  
  SizedBox(height: 10),
        CustomText(
            text: "Delivery Address", fontSize: 18, color: AppColors.white),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                'Address : ${widget.userAddress}',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _payWithCard,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade900,
            minimumSize: Size(double.infinity, 40),
          ),
          child: Text("Pay via Card",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 15),
        ElevatedButton(
          onPressed: _cashOnDelivery,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade900,
            minimumSize: Size(double.infinity, 40),
          ),
          child: Text("Cash on Delivery",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
