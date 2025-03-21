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
  bool _isLoading = false;

  // void _payWithCard() async {
    // setState(() {
      // _isLoading = true; // Show loader
    // });

    // bool paymentSuccess = false;
    // await StripeService.instance.makePayment(
      // widget.totalPrice,
      // widget.userAddress,
      // widget.cartItems,
      // context,
      // widget.userId,
    // ).then((success) {
      // paymentSuccess = true;
    // }).catchError((error) {
      // paymentSuccess = false;
    // });

    // setState(() {
      // _isLoading = false; // Hide loader
    // });

    // if (paymentSuccess) {
      // Navigator.pushReplacement(
        // context,
        // MaterialPageRoute(builder: (context) => OrderScreen()),
      // );
    // } else {
      // ScaffoldMessenger.of(context).showSnackBar(
        // SnackBar(
          // content: Text("Payment cancelled"),
          // backgroundColor: Colors.red,
          // duration: Duration(seconds: 2),
        // ),
      // );
    // }
  // }

  void _payWithCard() async {
  setState(() {
    _isLoading = true; // Show loader
  });

  bool paymentSuccess = await StripeService.instance.makePayment(
    widget.totalPrice,
    widget.userAddress,
    widget.cartItems,
    context,
    widget.userId,
  );

  setState(() {
    _isLoading = false; // Hide loader
  });

  if (paymentSuccess) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OrderScreen()),
    );
  } else {
    // Handle case when user cancels without entering details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment was cancelled."),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                      ),
                    ),
                    SizedBox(height: 20),
                    if(widget.cartItems.isNotEmpty)
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
                            style: TextStyle(color: Colors.white,fontSize: 16),
                          ),
                          Text(
                           '₹ ${widget.totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.orange, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                                        if(widget.cartItems.isNotEmpty)

                    _paymentMethods(),
                  ],
                ),
              ),
            ),
          ),
                              if(widget.cartItems.isNotEmpty)

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Colors.black,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _payWithCard,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 50),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.orange)
                  : Text(
                      "Confirm & Pay Now Via Stripe 😊",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
            ),
          ),
        ],
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
      ],
    );
  }
}
