import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:restaurent/constants/const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePayment(double totalPrice, String userAddress,
      List<Map<String, dynamic>> orderItems) async {
    try {
      String? paymentIntentClientSecret =
          await createPaymentStripe(totalPrice.toInt(), "usd");

      if (paymentIntentClientSecret == null) {
        print("Failed to create payment intent.");
        return;
      }

      // Initialize the payment sheet
      await Stripe.instance
          .initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "test",
        ),
      )
          .then((_) {
        print("Payment sheet initialized successfully.");
      }).catchError((error) {
        print("Error initializing payment sheet: $error");
        return;
      });

      // Present the payment sheet
      await _processPayment();

      // Insert order and payment details into Supabase
      final orderId = await _insertOrder(totalPrice, userAddress);
      if (orderId != null) {
        await _insertOrderItems(orderId, orderItems, totalPrice);
        await _insertPayment(orderId, totalPrice, paymentIntentClientSecret);
      }
    } catch (e) {
      print("Error during payment process: $e");
    }
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

      if (response.data != null) {
        print(response.data);
        return response.data["client_secret"];
      }
      return null;
    } catch (E) {
      print(E);
    }

    return null;
  }

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      await Stripe.instance.confirmPaymentSheetPayment();
      print("Payment successful!");
    } on StripeException catch (e) {
      print("Stripe error: ${e.error.localizedMessage}");
    } catch (e) {
      print("Unknown error during payment process: $e");
    }
  }

  
  
  Future<String?> _insertOrder(double totalAmount, String deliveryAddress) async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('orders')
      .insert({
        'user_id': supabase.auth.currentUser?.id, // Assuming user is logged in
        'total_amount': totalAmount,
        'status': 'pending', // or any initial status you want
        'delivery_address': deliveryAddress,
        'payment_status': 'completed', // Assuming payment is successful
      })
      .select()
      .single(); // Fetch the inserted row and get a single record

  print('Order inserted successfully');
  return response['id']; // Return the order ID
}

  
  
  
  
  
  
  
  

  
  
  
  
  
  
  
  

 
   Future<void> _insertOrderItems(
      String orderId, List<Map<String, dynamic>> orderItems, double totalPrice) async {
    final supabase = Supabase.instance.client;

    for (var item in orderItems) {
      final response = await supabase.from('order_items').insert({
        'order_id': orderId,
        'food_id': item['food_id'],
        'quantity': item['quantity'],
        'price': totalPrice,
      }); // FIX: Added .execute()
        print('Order item inserted successfully $response');

    
    
    
    
    
    }
  }

  Future<void> _insertPayment(
      String orderId, double amount, String stripePaymentId) async {
    final supabase = Supabase.instance.client;

    final response = await supabase.from('payments').insert({
      'order_id': orderId,
      'amount': amount,
      'payment_method': 'stripe',
      'payment_status': 'completed',
      'stripe_payment_id': stripePaymentId,
    });

    if (response != null) {
      print('Error inserting payment: ${response.error!.message}');
    } else {
      print('Payment inserted successfully');
    }
  }
 

 
 
 
 
 
 
 

 
 
 
 
 
 
 

 
 
 

 
 
 
 
 
 
 

 
 
 
 
 
 

  String _calculateAmount(int amount) {
    final calculateAmount = amount * 100; // Convert to cents for Stripe
    return calculateAmount.toString();
  }
}
