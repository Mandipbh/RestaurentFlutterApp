import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:restaurent/constants/colors.dart";
import "package:restaurent/providers/auth_provider.dart";
import "package:restaurent/providers/cart_provider.dart";
import "package:restaurent/screens/cart/widgets/order_summary.dart";
import "package:restaurent/screens/navigation/main-navigation.dart";
import "package:restaurent/screens/payment/payment_screen.dart";
import "package:restaurent/widgets/custom_text.dart";
import "package:supabase_flutter/supabase_flutter.dart";

class CartScreen extends ConsumerStatefulWidget {
  
  const
  CartScreen({super.key});

  @override
  ConsumerState
  createState()
  =>
  _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  String?
  _userAddress;
  String?
  _userId;

  @override
  void
  initState() {
    super.initState();

    _fetchUserDetails();
    final
    user = ref.read(authProvider);
    if (user != null) {
      ref.read(cartProvider.notifier).fetchCart(user.id);
    }
  }

  Future<void>
  _fetchUserDetails()
  async {
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
  Widget
  build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final user = ref.watch(authProvider);

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
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => MainNavigation())),
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

                        print('cartItems  new >> $cartItems');

                
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(
                                totalPrice: calculateTotalAmount(cartItems),
                                userAddress:
                                    _userAddress ?? "No address available",
                                userId: _userId ?? '',
                                cartItems: cartItems),
                          ),
                        );
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade900,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        "Order Now",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  

  double
  calculateTotalAmount(List<Map<String, dynamic>> cartItems) {
    double subtotal = 0.0;
    double gst = 0.0;
    double deliveryFee = 30.0; 




    for (var item in cartItems) {
      double price = 0.0;
      if (item['food_items'] != null && item['food_items']['price'] != null) {
        price = double.parse(item['food_items']['price'].toString());
      } else if (item['combination_breakfast'] != null && item['combination_breakfast']['price'] != null) {
        price = double.parse(item['combination_breakfast']['price'].toString());
      } else if (item['recommended_breakfast'] != null && item['recommended_breakfast']['price'] != null) {
 price = double.parse(item['recommended_breakfast']['price'].toString());
      }else if (item['all_foods'] != null && item['all_foods']['price'] != null) {
price = double.parse(item['all_foods']['price'].toString());
      }
      
      int quantity = item['quantity'] as int? ?? 1;
      subtotal += price * quantity;
    }

    gst = subtotal * 0.05;
    double totalAmount = subtotal + gst + deliveryFee;
    return totalAmount;
  }

  Map<String, double>
  getOrderBreakdown(List<Map<String, dynamic>> cartItems) {
    double subtotal = 0.0;

    for (var item in cartItems) {
      double price = 0.0;
      if (item['food_items'] != null && item['food_items']['price'] != null) {
        price = double.parse(item['food_items']['price'].toString());
      } else if (item['combination_breakfast'] != null && item['combination_breakfast']['price'] != null) {
        price = double.parse(item['combination_breakfast']['price'].toString());
      }else if (item['recommended_breakfast'] != null && item['recommended_breakfast']['price'] != null) {
price = double.parse(item['recommended_breakfast']['price'].toString());
      }
      
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

