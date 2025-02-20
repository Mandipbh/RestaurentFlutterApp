import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/providers/auth_provider.dart';
import 'package:restaurent/providers/cart_provider.dart';


class CartScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final user = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: cartItems.isEmpty
          ? Center(child: Text("Cart is empty"))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  title: Text(item['food_items']['name']),
                  subtitle: Text("Quantity: ${item['quantity']}"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      ref.read(cartProvider.notifier).removeFromCart(item['id'],user!.id);
                    },
                  ),
                );
              },
            ),
    );
  }
}