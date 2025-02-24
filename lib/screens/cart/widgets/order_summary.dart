import 'package:flutter/material.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/constants/responsive.dart';
import 'package:restaurent/screens/cart/widgets/cart_item_list.dart';
import 'package:restaurent/screens/cart/widgets/location_display.dart';
import 'package:restaurent/screens/cart/widgets/order_total_summary.dart';
import 'package:restaurent/widgets/custom_divider.dart';
import 'package:restaurent/widgets/custom_sizebox.dart';
import 'package:restaurent/widgets/custom_text.dart';

class OrderSummary extends StatelessWidget {
  final List cartItems;
  final double totalPrice;
  final String userId;
  final String location;
  final VoidCallback onEditLocation;

  const OrderSummary({
    super.key,
    required this.cartItems,
    required this.totalPrice,
    required this.userId,
    required this.location,
    required this.onEditLocation,
  });

  @override
  Widget build(BuildContext context) {
    double totalPrice = cartItems.fold(0, (sum, item) {
      double itemPrice = (item['food_items']['price'] ?? 0).toDouble();
      int quantity = (item['quantity'] ?? 1);
      return sum + (itemPrice * quantity);
    });

    double gstRate = 0.05;
    double gst = totalPrice * gstRate;
    double deliveryFee = 50.0;

    double grandTotal = totalPrice + gst + deliveryFee;

    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 22, 22, 22),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Order Summary",
                  fontSize: 18,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
                CustomSizedBox.h5,
                CartItemList(cartItems: cartItems, userId: userId, isPayment: false,),
                CustomSizedBox.h10,
                CustomDivider(
                  color: Colors.grey[800]!,
                  thickness: 1.5,
                  indent: ScreenSize.width(context) * 0.00,
                  endIndent: ScreenSize.width(context) * 0.00,
                ),
                SizedBox(height: 10),
                LocationDisplay(
                  location: location,
                  onEdit: onEditLocation,
                ),
                SizedBox(height: 10),
                CustomDivider(
                  color: Colors.grey[800]!,
                  thickness: 1.5,
                  indent: ScreenSize.width(context) * 0.00,
                  endIndent: ScreenSize.width(context) * 0.00,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "Rate:",
                        fontSize: 18,
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      CustomText(
                        text: "₹ ${totalPrice.toStringAsFixed(2)}",
                        fontSize: 18,
                        color: AppColors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          CustomSizedBox.h35,
          OrderTotalSummary(
            totalPrice: totalPrice,
            gst: gst,
            deliveryFee: deliveryFee,
            grandTotal: grandTotal,
          ),
        ],
      ),
    );
  }
}
