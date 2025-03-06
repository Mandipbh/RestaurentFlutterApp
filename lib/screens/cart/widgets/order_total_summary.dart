import 'package:flutter/material.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/constants/responsive.dart';
import 'package:restaurent/widgets/custom_divider.dart';
import 'package:restaurent/widgets/custom_sizebox.dart';
import 'package:restaurent/widgets/custom_text.dart';

class OrderTotalSummary extends StatelessWidget {
  final double totalPrice;
  final double gst;
  final double deliveryFee;
  final double grandTotal;

  const OrderTotalSummary({
    super.key,
    required this.totalPrice,
    required this.gst,
    required this.deliveryFee,
    required this.grandTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
      decoration: BoxDecoration(
              color: const Color.fromARGB(255, 22, 22, 22),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Subtotal",
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
          Container(
            padding: EdgeInsets.only(top: 40, bottom: 10, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "GST",
                  fontSize: 14,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
                CustomText(
                  text: "₹ ${gst.toStringAsFixed(2)}",
                  fontSize: 14,
                  color: AppColors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Delivery partner fee for 17km",
                  fontSize: 14,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
                CustomText(
                  text: "₹ ${deliveryFee.toStringAsFixed(2)}",
                  fontSize: 14,
                  color: AppColors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
          CustomSizedBox.h20,
          CustomSizedBox.h5,
          CustomDivider(
            color: Colors.grey[800]!,
            thickness: 1.5,
            indent: ScreenSize.width(context) * 0.00,
            endIndent: ScreenSize.width(context) * 0.00,
          ),
          Container(
            padding: EdgeInsets.only(top: 25, left: 10, right: 10, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Grand Total",
                  fontSize: 18,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
                CustomText(
                  text: "₹ ${grandTotal.toStringAsFixed(2)}",
                  fontSize: 18,
                  color: AppColors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  
}
