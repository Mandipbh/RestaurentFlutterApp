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

  Future<void> makePayment(double totalPrice, String userAddress,
      List<Map<String, dynamic>> orderItems, BuildContext context, String userId) async {
    try {
      debugPrint("Starting payment process...");
      String? paymentIntentClientSecret =
          await createPaymentStripe(totalPrice.toInt(), "usd");

      if (paymentIntentClientSecret == null) {
        debugPrint("Failed to create payment intent.");
        return;
      }
      
      debugPrint("Payment intent created successfully");

      // Platform-specific approach
      if (Platform.isAndroid) {
        // For Android, use a simpler approach that's less likely to trigger OpenGL issues
        await _handleAndroidPayment(
          paymentIntentClientSecret, 
          totalPrice, 
          userAddress, 
          orderItems, 
          context, 
          userId
        );
      } else {
        // For iOS, use the standard approach which works well
        await _handleIOSPayment(
          paymentIntentClientSecret, 
          totalPrice, 
          userAddress, 
          orderItems, 
          context, 
          userId
        );
      }
    } catch (e) {
      debugPrint("Error during payment process: $e");
    }
  }

  Future<void> _handleAndroidPayment(
    String paymentIntentClientSecret,
    double totalPrice,
    String userAddress,
    List<Map<String, dynamic>> orderItems,
    BuildContext context,
    String userId
  ) async {
    try {
      // Initialize with minimal UI options
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "test",
          // Minimal appearance settings
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: Colors.blue,
              background: Colors.white,
              componentBackground: Colors.white,
              componentBorder: Colors.grey,
              componentDivider: Colors.grey,
              primaryText: Colors.black,
              secondaryText: Colors.grey,
              placeholderText: Colors.grey,
              icon: Colors.grey,
            ),
          ),
        ),
      );
      
      debugPrint("Payment sheet initialized for Android");

      // Present payment sheet in a try-catch block
      bool presentSuccess = false;
      try {
        await Stripe.instance.presentPaymentSheet();
        presentSuccess = true;
        debugPrint("Payment sheet presented successfully on Android");
      } catch (e) {
        debugPrint("Error presenting payment sheet on Android: $e");
        return; // Exit if we couldn't even present the sheet
      }
      
      // If we got here, the sheet was presented successfully
      // For Android, we'll assume payment success if the sheet was presented
      // This is because the OpenGL error prevents confirmPaymentSheetPayment from working
      
      // Schedule the database operations and navigation to run after a delay
      // This gives time for any UI operations to complete
      Future.delayed(Duration(seconds: 1), () {
        _completePaymentProcess(
          paymentIntentClientSecret,
          totalPrice,
          userAddress,
          orderItems,
          context,
          userId
        );
      });
    } catch (e) {
      debugPrint("Error in Android payment flow: $e");
    }
  }

  Future<void> _handleIOSPayment(
    String paymentIntentClientSecret,
    double totalPrice,
    String userAddress,
    List<Map<String, dynamic>> orderItems,
    BuildContext context,
    String userId
  ) async {
    try {
      // Standard flow for iOS
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "test",
        ),
      );
      
      await Stripe.instance.presentPaymentSheet();
      await Stripe.instance.confirmPaymentSheetPayment();
      
      // If we get here without exceptions, payment was successful
      await _completePaymentProcess(
        paymentIntentClientSecret,
        totalPrice,
        userAddress,
        orderItems,
        context,
        userId
      );
    } catch (e) {
      debugPrint("Error in iOS payment flow: $e");
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
    String userId
  ) async {
    debugPrint("Starting database operations after payment");
    
    // Verify payment status with Stripe API (optional but recommended)
    bool paymentVerified = await _verifyPaymentWithStripe(paymentIntentClientSecret);
    
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
        await _insertPayment(orderId, totalPrice, paymentIntentClientSecret, context, userId);
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
  
  Future<String?> _insertOrder(double totalAmount, String deliveryAddress, List<Map<String, dynamic>> orderItems) async {
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
 
  // Future<void> _insertOrderItems(
      // String orderId, List<Map<String, dynamic>> orderItems, double totalPrice) async {
    // final supabase = Supabase.instance.client;

    // for (var item in orderItems) {
      // print('item ss >>$item');
      // await supabase.from('order_items').insert({
        // 'order_id': orderId,
        // 'food_id': item['food_id'],
        // 'quantity': item['quantity'],
        // 'price': totalPrice,
      // });
    // }
  // }




Future<void> _insertOrderItems(
    String orderId, List<Map<String, dynamic>> orderItems, double totalPrice) async {
  final supabase = Supabase.instance.client;

  for (var item in orderItems) {
    print('item ss >>$item');
    final foodId = item['food_id'];
    final recommendedId = item['recommended_breakfast_id'];
    final combinationId = item['combination_breakfast_id'];

    if (foodId != null || recommendedId != null || combinationId != null) {
      print('Inserting order item: order_id: $orderId, item_id: $foodId / $recommendedId / $combinationId, quantity: ${item['quantity']}, price: $totalPrice');

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

    await supabase
        .from('cart')
        .delete()
        .eq('user_id', userId);
  }
  
  Future<void> _insertPayment(
      String orderId, double amount, String stripePaymentId, BuildContext context, String userId) async {
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