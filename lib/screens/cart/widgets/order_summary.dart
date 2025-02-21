import 'package:flutter/material.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/constants/responsive.dart';
import 'package:restaurent/screens/cart/widgets/cart_item_list.dart';
import 'package:restaurent/screens/cart/widgets/location_display.dart';
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
    Key? key,
    required this.cartItems,
    required this.totalPrice,
    required this.userId,
    required this.location,
    required this.onEditLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF2E2E2E),
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
                CustomSizedBox.h10,
                CartItemList(cartItems: cartItems, userId: userId),
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
                        text: "\₹ ${totalPrice.toStringAsFixed(2)}",
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
        ],
      ),
    );
  }
}
