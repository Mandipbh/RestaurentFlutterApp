import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/providers/auth_provider.dart';
import 'package:restaurent/providers/cart_provider.dart';
import 'package:restaurent/screens/cart/widgets/order_summary.dart';
import 'package:restaurent/screens/navigation/main-navigation.dart';
import 'package:restaurent/screens/payment/payment_screen.dart';
import 'package:restaurent/widgets/custom_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  String? _userAddress;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final user = ref.read(authProvider);
    if (user != null) {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('users')
          .select('address')
          .eq('id', user.id)
          .single();

      if (response['address'] != null) {
        setState(() {
          _userAddress = response['address'];
          _userId = user.id;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final user = ref.watch(authProvider);

    print('User data: $user');
    print('User Address: $_userAddress');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Cart",
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.black,
         leading: IconButton(
   icon: Icon(Icons.arrow_back, color: AppColors.white),
   onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MainNavigation() )),
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
                      totalPrice: 40,
                      userId: user!.id,
                      location: _userAddress ?? 'No address available',
                      onEditLocation: () {},
                    ),
                  
                  
                  
                  
                  ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          totalPrice: calculateTotalAmount(cartItems), // Pass calculated total price
          userAddress: _userAddress ?? "No address available",
          userId: _userId ?? '',
          cartItems: cartItems
        ),
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.grey.shade900,
    minimumSize: Size(double.infinity, 50),
  ),
  child: Text(
    "Order Now",
    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
  ),
),
                  
                  
                  
                  
                  
                  
                  
                  
                  
                  
                  ],
                ),
              ),
            ),
    );
  }
  // lib/utils/cart_utils.dart

  double calculateTotalAmount(List<Map<String, dynamic>> cartItems) {
    double subtotal = 0.0;
    double gst = 0.0;
    double deliveryFee = 30.0; // You can make this configurable

    // Calculate subtotal
    for (var item in cartItems) {
      double price = double.parse(item['food_items']['price'].toString());
      int quantity = item['quantity'] as int;
      subtotal += price * quantity;
    }

    // Calculate GST (assuming 5% GST)
    gst = subtotal * 0.05;

    // Total amount including GST and delivery fee
    double totalAmount = subtotal + gst + deliveryFee;

    return totalAmount;
  }

  Map<String, double> getOrderBreakdown(List<Map<String, dynamic>> cartItems) {
    double subtotal = 0.0;

    // Calculate subtotal
    for (var item in cartItems) {
      double price = double.parse(item['food_items']['price'].toString());
      int quantity = item['quantity'] as int;
      subtotal += price * quantity;
    }

    // Calculate other components
    double gst = subtotal * 0.05;
    double deliveryFee = 30.0;
    double total = subtotal + gst + deliveryFee;

    return {
      'subtotal': subtotal,
      'gst': gst,
      'deliveryFee': deliveryFee,
      'total': total,
    };
  }
}
