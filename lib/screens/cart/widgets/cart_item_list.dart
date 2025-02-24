import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/providers/cart_provider.dart';
import 'package:restaurent/widgets/custom_text.dart';

class CartItemList extends ConsumerWidget {
  final List<dynamic> cartItems;
  final String userId;
  final bool isPayment;

  const CartItemList(
      {super.key,
      required this.cartItems,
      required this.userId,
      required this.isPayment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        itemCount: cartItems.length,
        padding: EdgeInsets.symmetric(vertical: 10),
        itemBuilder: (context, index) {
          final item = cartItems[index];

          return Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 22, 22, 22),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    item['food_items']['image_url'],
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
                        text: item['food_items']['name'],
                        fontSize: 16,
                        color: AppColors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: "₹${item['food_items']['price']}",
                            fontSize: 14,
                            color: AppColors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      if (!isPayment)
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove, color: Colors.white70),
                              onPressed: () {
                                if (item['quantity'] > 1) {
                                  ref
                                      .read(cartProvider.notifier)
                                      .updateQuantity(
                                        item['id'],
                                        userId,
                                        item['quantity'] - 1,
                                      );
                                }
                              },
                            ),
                            CustomText(
                              text: item['quantity'].toString(),
                              fontSize: 14,
                              color: AppColors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                            IconButton(
                              icon: Icon(Icons.add, color: Colors.white70),
                              onPressed: () {
                                ref.read(cartProvider.notifier).updateQuantity(
                                      item['id'],
                                      userId,
                                      item['quantity'] + 1,
                                    );
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                if (!isPayment)
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.redAccent),
                    iconSize: 22,
                    onPressed: () {
                      ref.read(cartProvider.notifier).removeFromCart(
                            item['id'],
                            userId,
                          );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
