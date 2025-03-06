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
  final String userId;

  const PaymentScreen({
    super.key,
    required this.totalPrice,
    required this.userAddress,
    required this.cartItems,
    required this.userId,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  void _payWithCard() {
    StripeService.instance.makePayment(
      widget.totalPrice,
      widget.userAddress,
      widget.cartItems,
      context,
      widget.userId,
    );
  }

  void _cashOnDelivery() {
    print("Cash on Delivery selected");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    print('widget.totalPrice ${widget.totalPrice}');

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  child: CartItemList(
                cartItems: widget.cartItems,
                userId: user!.id,
                isPayment: true,
                onQuantityChanged: () {},
              )),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Price:',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      widget.totalPrice.toStringAsFixed(2),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              _paymentMethods(),
            ],
          ),
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
          text: "Delivery Address",
          fontSize: 18,
          color: AppColors.white,
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.location_on, color: AppColors.orange, size: 24),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Address: ${widget.userAddress}',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Text("Pay via Credit & Debit Cards",
            style: TextStyle(color: Colors.white, fontSize: 18)),
        ElevatedButton(
          onPressed: () {
            _payWithCard();

            // Navigator.push(
            // context,
            // MaterialPageRoute(
            // builder: (context) => PaymentMethodsScreen(payWithCard: _payWithCard),
            // ),
// );
//
            //
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade900,
            minimumSize: Size(double.infinity, 50),
          ),
          child: Text(
            "Pay Now",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
