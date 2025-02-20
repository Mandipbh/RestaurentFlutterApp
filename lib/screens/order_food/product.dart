import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final dynamic food; 
  const ProductItem({Key? key, required this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Image.asset(food['imageUrl'] ?? 'assets/default_image.png', width: 50, height: 50), 
        title: Text(food['name'] ?? 'Food Name'), 
        subtitle: Text('\$${food['price']}'),
        trailing: IconButton(
          icon: Icon(Icons.add_shopping_cart),
          onPressed: () {
         
          },
        ),
      ),
    );
  }
}