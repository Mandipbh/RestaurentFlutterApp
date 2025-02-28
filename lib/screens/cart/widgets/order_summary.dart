import 'package:flutter/material.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/constants/responsive.dart';
import 'package:restaurent/screens/cart/widgets/cart_item_list.dart';
import 'package:restaurent/screens/cart/widgets/location_display.dart';
import 'package:restaurent/screens/cart/widgets/order_total_summary.dart';
import 'package:restaurent/widgets/custom_divider.dart';
import 'package:restaurent/widgets/custom_sizebox.dart';
import 'package:restaurent/widgets/custom_text.dart';

class OrderSummary extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final String userId;
  final String location;
  final VoidCallback onEditLocation;

  const OrderSummary({
    super.key,
    required this.cartItems,
    required this.userId,
    required this.location,
    required this.onEditLocation, required int totalPrice, 
  });

  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateTotalPrice();
  }

  void _calculateTotalPrice() {
    double tempTotal = 0.0;

    for (var item in widget.cartItems) {
      // Check for both food_items and combination_breakfast
      var foodItems = item['food_items'];
      var combinationBreakfast = item['combination_breakfast'];
      var recommendedBreakfast = item['recommended_breakfast'];
      
      // Get price from either food_items or combination_breakfast
      double itemPrice = 0.0;
      if (foodItems != null && foodItems['price'] != null) {
        itemPrice = double.parse(foodItems['price'].toString());
      } else if (combinationBreakfast != null && combinationBreakfast['price'] != null) {
        itemPrice = double.parse(combinationBreakfast['price'].toString());
      }else if (recommendedBreakfast != null && recommendedBreakfast['price'] != null) {
itemPrice = double.parse(recommendedBreakfast['price'].toString());
      }
      
      int quantity = item['quantity'] ?? 1;
      tempTotal += (itemPrice * quantity);
    }

    setState(() {
      totalPrice = tempTotal;
    });
  }

  void _onQuantityChanged() {
    // Recalculate price when quantity changes
    setState(() {
      _calculateTotalPrice();
    });
  }

  @override
  void didUpdateWidget(OrderSummary oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Recalculate if cart items change
    if (widget.cartItems != oldWidget.cartItems) {
      _calculateTotalPrice();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                CartItemList(
                  cartItems: widget.cartItems,
                  userId: widget.userId,
                  isPayment: false,
                  onQuantityChanged: _onQuantityChanged, // Pass the callback
                ),
                CustomSizedBox.h10,
                CustomDivider(
                  color: Colors.grey[800]!,
                  thickness: 1.5,
                  indent: ScreenSize.width(context) * 0.00,
                  endIndent: ScreenSize.width(context) * 0.00,
                ),
                
                SizedBox(height: 10),
                LocationDisplay(
                  location: widget.location,
                  onEdit: widget.onEditLocation,
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
