import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/providers/auth_provider.dart';
import 'package:restaurent/providers/cart_provider.dart';
import 'package:restaurent/screens/cart/widgets/order_summary.dart';
import 'package:restaurent/screens/cart/widgets/order_total_summary.dart';
import 'package:restaurent/widgets/custom_bottombar.dart';
import 'package:restaurent/widgets/custom_sizebox.dart';
import 'package:restaurent/widgets/custom_text.dart';

class CartScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartNotifier = ref.read(cartProvider.notifier);
    final cartItems = ref.watch(cartProvider);

    final user = ref.watch(authProvider);
    final userMetadata = user?.userMetadata;
    final userName = userMetadata?['full_name'];
    final userAddress = userMetadata?['address'];
    // print('userAddress->>> $userAddress');

    // Fetch cart items after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (user != null) {
        cartNotifier.fetchCart(user.id);
      }
    });

    // Calculate total price
    double totalPrice = cartItems.fold(0,
        (sum, item) => sum + (item['food_items']['price'] * item['quantity']));

    String location = "Block-J, Sector-10, Rohini, Delhi";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cart",
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.black,
        leading: IconButton(
          icon: Icon(Icons.chevron_left_sharp, color: AppColors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: cartItems.isEmpty
          ? Container(
              color: AppColors.black,
              child: Center(
                child: CustomText(
                  text: 'Cart is Empty',
                  fontSize: 16,
                  color: AppColors.white,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                color: AppColors.black,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    OrderSummary(
                      cartItems: cartItems,
                      totalPrice: totalPrice,
                      userId: user!.id,
                      location: location,
                      onEditLocation: () {},
                    ),
                    CustomSizedBox.h35,
                    OrderTotalSummary(
                      totalPrice: totalPrice,
                      gst: 21,
                      deliveryFee: 50,
                      grandTotal: 89.97,
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: CustomBottomNavBar(showButtonBottomNavBar: true),
    );
  }
}
