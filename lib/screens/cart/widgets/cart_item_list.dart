import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/providers/cart_provider.dart';
import 'package:restaurent/widgets/custom_text.dart';

class CartItemList extends ConsumerWidget {
  final List<dynamic> cartItems;
  final String userId;
  final bool isPayment;
  final VoidCallback onQuantityChanged;

  const CartItemList({
    super.key,
    required this.cartItems,
    required this.userId,
    required this.isPayment,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: cartItems.length,
      padding: EdgeInsets.symmetric(vertical: 10),
      shrinkWrap: true, // Ensures dynamic height
      physics: NeverScrollableScrollPhysics(), // Prevents internal scrolling
      itemBuilder: (context, index) {
        final item = cartItems[index];
    
        final foodItem = item['food_items'];
        final combinationBreakfast = item['combination_breakfast'];
        final recommendedBreakfast = item['recommended_breakfast'];
    
        final imageUrl = foodItem?['image_url'] ??
            combinationBreakfast?['image_url'] ??
            recommendedBreakfast?['image_url'] ??
            'https://via.placeholder.com/80';
    
        final name = foodItem?['name'] ??
            combinationBreakfast?['name'] ??
            recommendedBreakfast?['name'] ??
            'Unknown Item';
    
        final price = foodItem?['price'] != null
            ? double.parse(foodItem!['price'].toString())
            : combinationBreakfast?['price'] != null
                ? double.parse(combinationBreakfast!['price'].toString())
                : recommendedBreakfast?['price'] != null
                    ? double.parse(recommendedBreakfast!['price'].toString())
                    : 0.0;
    
        return Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 22, 22, 22),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: name,
                      fontSize: 16,
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 5),
                    CustomText(
                      text: "₹${price.toStringAsFixed(2)}",
                      fontSize: 14,
                      color: AppColors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 5),
                    if (!isPayment)
                      Container(
                        width: 140,
                        height: 45,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.black, AppColors.homeScreenBg],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (item['quantity'] > 1) {
                                  ref
                                      .read(cartProvider.notifier)
                                      .updateQuantity(
                                        item['id'],
                                        userId,
                                        item['quantity'] - 1,
                                      )
                                      .then((_) {
                                    onQuantityChanged();
                                  });
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.grey.shade900,
                                radius: 18,
                                child: Icon(Icons.remove,
                                    color: AppColors.white, size: 20),
                              ),
                            ),
                            CustomText(
                              text: item['quantity'].toString(),
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            GestureDetector(
                              onTap: () {
                                ref
                                    .read(cartProvider.notifier)
                                    .updateQuantity(
                                      item['id'],
                                      userId,
                                      item['quantity'] + 1,
                                    )
                                    .then((_) {
                                  onQuantityChanged();
                                });
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.grey.shade900,
                                radius: 18,
                                child: Icon(Icons.add,
                                    color: AppColors.white, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (!isPayment)
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.redAccent),
                  iconSize: 22,
                  onPressed: () {
                    ref
                        .read(cartProvider.notifier)
                        .removeFromCart(
                          item['id'],
                          userId,
                        )
                        .then((_) {
                      onQuantityChanged();
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}