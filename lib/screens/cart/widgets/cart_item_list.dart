import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/widgets/custom_text.dart';
import 'package:restaurent/providers/cart_provider.dart';

class CartItemList extends ConsumerWidget {
  final List<dynamic> cartItems;
  final String userId;

  const CartItemList({Key? key, required this.cartItems, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 250, // Ensuring it has a defined height
      child: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 5),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8), // Optional border radius
              child: Image.network(
                item['food_items']['image_url'],
                width: 100,
                height: 100,
                fit: BoxFit.cover, // Ensure the image covers the space
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.image,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: item['food_items']['name'],
                  fontSize: 16,
                  color: AppColors.white70,
                  fontWeight: FontWeight.w500,
                ),
                CustomText(
                  text: "Price: ${item['food_items']['price'].toString()}",
                  fontSize: 14,
                  color: AppColors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Qty: ${item['quantity']}",
                  style: TextStyle(color: AppColors.white70),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: AppColors.white70),
                  iconSize: 20,
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
