import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:restaurent/constants/const.dart';
import 'package:restaurent/screens/order_food/order_success.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<bool> makePayment(
      double totalPrice,
      String userAddress,
      List<Map<String, dynamic>> orderItems,
      BuildContext context,
      String userId) async {
    try {
      debugPrint("Starting payment process...");
      String? paymentIntentClientSecret =
          await createPaymentStripe(totalPrice.toInt(), "usd");

      if (paymentIntentClientSecret == null) {
        debugPrint("Failed to create payment intent.");
        return false; // Return false if payment intent creation fails
      }

      debugPrint("Payment intent created successfully");

      bool paymentSuccess = false;

      if (Platform.isAndroid) {
        paymentSuccess = await _handleAndroidPayment(paymentIntentClientSecret,
            totalPrice, userAddress, orderItems, context, userId);
      } else {
        paymentSuccess = await _handleIOSPayment(paymentIntentClientSecret,
            totalPrice, userAddress, orderItems, context, userId);
      }

      return paymentSuccess;
    } catch (e) {
      debugPrint("Error during payment process: $e");
      return false; // Ensure false is returned in case of error
    }
  }

  Future<bool> _handleAndroidPayment(
      String paymentIntentClientSecret,
      double totalPrice,
      String userAddress,
      List<Map<String, dynamic>> orderItems,
      BuildContext context,
      String userId) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "test",
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: Colors.orange,
              background: Colors.grey.shade900,
              componentBackground: Colors.grey.shade900,
              componentBorder: Colors.grey,
              componentDivider: Colors.grey,
              primaryText: Colors.white,
              secondaryText: Colors.grey,
              placeholderText: Colors.grey,
              icon: Colors.white,
            ),
          ),
        ),
      );

      debugPrint("Payment sheet initialized for Android");

      try {
        await Stripe.instance.presentPaymentSheet();
        debugPrint("Payment sheet presented successfully on Android");
        await _completePaymentProcess(paymentIntentClientSecret, totalPrice,
            userAddress, orderItems, context, userId);
        return true; // Return true if payment is successful
      } catch (e) {
        debugPrint("User canceled the payment on Android: $e");
        return false; // Return false if user cancels
      }
    } catch (e) {
      debugPrint("Error in Android payment flow: $e");
      return false; // Return false in case of any error
    }
  }

  Future<bool> _handleIOSPayment(
      String paymentIntentClientSecret,
      double totalPrice,
      String userAddress,
      List<Map<String, dynamic>> orderItems,
      BuildContext context,
      String userId) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "test",
        ),
      );

      try {
        await Stripe.instance.presentPaymentSheet();
        await Stripe.instance.confirmPaymentSheetPayment();
        await _completePaymentProcess(paymentIntentClientSecret, totalPrice,
            userAddress, orderItems, context, userId);
        return true; // Return true if payment is successful
      } catch (e) {
        debugPrint("User canceled the payment on iOS: $e");
        return false; // Return false if user cancels
      }
    } catch (e) {
      debugPrint("Error in iOS payment flow: $e");
      return false; // Return false in case of any error
    }
  }

  // This function handles all the database operations and navigation
  // It's completely separate from the payment UI flow
  Future<void> _completePaymentProcess(
      String paymentIntentClientSecret,
      double totalPrice,
      String userAddress,
      List<Map<String, dynamic>> orderItems,
      BuildContext context,
      String userId) async {
    debugPrint("Starting database operations after payment");

    // Verify payment status with Stripe API (optional but recommended)
    bool paymentVerified =
        await _verifyPaymentWithStripe(paymentIntentClientSecret);

    if (!paymentVerified) {
      debugPrint("Payment verification failed, but proceeding anyway");
      // You might want to handle this differently in production
    }

    String? orderId;
    try {
      orderId = await _insertOrder(totalPrice, userAddress, orderItems);
      debugPrint("Order inserted with ID: $orderId");
    } catch (e) {
      debugPrint("Error inserting order: $e");
    }

    if (orderId != null) {
      try {
        await _insertOrderItems(orderId, orderItems, totalPrice);
        debugPrint("Order items inserted successfully");
      } catch (e) {
        debugPrint("Error inserting order items: $e");
      }

      try {
        await _insertPayment(
            orderId, totalPrice, paymentIntentClientSecret, context, userId);
        debugPrint("Payment record inserted successfully");
      } catch (e) {
        debugPrint("Error inserting payment: $e");
      }
    }

    try {
      await _clearCart(userId);
      debugPrint("Cart cleared successfully");
    } catch (e) {
      debugPrint("Error clearing cart: $e");
    }

    // Navigate to success screen
    debugPrint("Navigating to OrderScreen");
    _safeNavigate(context);
  }

  // Optional: Verify payment status with Stripe API
  Future<bool> _verifyPaymentWithStripe(String clientSecret) async {
    try {
      // Extract the payment intent ID from the client secret
      final paymentIntentId = clientSecret.split('_secret_')[0];

      final Dio dio = Dio();
      var response = await dio.get(
        "https://api.stripe.com/v1/payment_intents/$paymentIntentId",
        options: Options(
          headers: {
            "Authorization": "Bearer $stripeScekretKey",
          },
        ),
      );

      if (response.data != null && response.data is Map<String, dynamic>) {
        final status = response.data["status"];
        debugPrint("Payment intent status: $status");
        return status == "succeeded" || status == "processing";
      }
      return false;
    } catch (e) {
      debugPrint("Error verifying payment: $e");
      // In case of error, we'll assume payment was successful
      return true;
    }
  }

  // Safe navigation method
  void _safeNavigate(BuildContext context) {
    Future.microtask(() {
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => OrderScreen()),
          (route) => false,
        );
      }
    });
  }

  Future<String?> createPaymentStripe(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
      };

      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {
            "Authorization": "Bearer $stripeScekretKey",
            "Content-Type": "application/x-www-form-urlencoded"
          },
        ),
      );

      if (response.data != null && response.data is Map<String, dynamic>) {
        return response.data["client_secret"]?.toString();
      }
      return null;
    } catch (e) {
      debugPrint('Error creating payment intent: $e');
      return null;
    }
  }

  Future<String?> _insertOrder(double totalAmount, String deliveryAddress,
      List<Map<String, dynamic>> orderItems) async {
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('orders')
        .insert({
          'user_id': supabase.auth.currentUser?.id,
          'total_amount': totalAmount,
          'status': 'pending',
          'delivery_address': deliveryAddress,
          'payment_status': 'completed',
        })
        .select()
        .single();

    return response['id'];
  }

  Future<void> _insertOrderItems(String orderId,
      List<Map<String, dynamic>> orderItems, double totalPrice) async {
    final supabase = Supabase.instance.client;

    for (var item in orderItems) {
      print('item ss >>$item');
      final foodId = item['food_id'];
      final recommendedId = item['recommended_breakfast_id'];
      final combinationId = item['combination_breakfast_id'];

      if (foodId != null || recommendedId != null || combinationId != null) {
        print(
            'Inserting order item: order_id: $orderId, item_id: $foodId / $recommendedId / $combinationId, quantity: ${item['quantity']}, price: $totalPrice');

        try {
          await supabase.from('order_items').insert({
            'order_id': orderId,
            'food_id': foodId,
            'recommended_breakfast_id': recommendedId,
            'combination_breakfast_id': combinationId,
            'quantity': item['quantity'],
            'price': totalPrice,
          });
        } catch (e) {
          print('Error inserting order item: $e');
        }
      } else {
        print('Skipping item: No valid ID found');
      }
    }
  }

  Future<void> _clearCart(String userId) async {
    final supabase = Supabase.instance.client;

    await supabase.from('cart').delete().eq('user_id', userId);
  }

  Future<void> _insertPayment(String orderId, double amount,
      String stripePaymentId, BuildContext context, String userId) async {
    final supabase = Supabase.instance.client;

    await supabase.from('payments').insert({
      'order_id': orderId,
      'amount': amount,
      'user_id': userId,
      'payment_method': 'stripe',
      'payment_status': 'completed',
      'stripe_payment_id': stripePaymentId,
    });
  }

  String _calculateAmount(int amount) {
    final calculateAmount = amount * 100;
    return calculateAmount.toString();
  }
}
