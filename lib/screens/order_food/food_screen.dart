import 'package:flutter/material.dart';
import 'package:restaurent/model/food_item.dart';
import 'package:restaurent/services/food_service.dart';

class FoodListScreen extends StatefulWidget {
  @override
  _FoodListScreenState createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  late Future<List<FoodItem>> foodItemsFuture;

  @override
  void initState() {
    super.initState();
    foodItemsFuture = FoodService().fetchFoodItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Food Menu")),
      body: FutureBuilder<List<FoodItem>>(
        future: foodItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error loading food items"));
          }
          final foodItems = snapshot.data ?? [];
          return ListView.builder(
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              final food = foodItems[index];
              return Card(
                child: ListTile(
                  leading: food.imageUrl.isNotEmpty
                      ? Image.network(food.imageUrl,
                          width: 50, height: 50, fit: BoxFit.cover)
                      : Icon(Icons.fastfood),
                  title: Text(food.name),
                  subtitle: Text("\$${food.price.toStringAsFixed(2)}"),
                  onTap: () {
                    // Add navigation to details page
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
