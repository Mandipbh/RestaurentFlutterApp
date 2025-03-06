import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/providers/food_provider.dart';
import 'package:restaurent/screens/order_food/food_detail_screen.dart';


class FoodListScreen extends ConsumerWidget {
  final String restaurantId;

  const FoodListScreen({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodList = ref.watch(foodItemsProvider(restaurantId));

    return Scaffold(
 appBar: AppBar(
   title:
       Text("Foods", style: TextStyle(color: AppColors.white)),
   backgroundColor: AppColors.black,
   leading: IconButton(
     icon: Icon(Icons.arrow_back, color: AppColors.white),
         onPressed: () => Navigator.pop(context),
   ),
 ),
 backgroundColor: Colors.black,         
  body: foodList.when(
        data: (foods) => foods.isEmpty
            ? Center(child: Text("No food available"))
            : ListView.builder(
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  final food = foods[index];
                  return GestureDetector(
                    onTap: () {
                       Navigator.push(
   context,
   MaterialPageRoute(
     builder: (context) =>
         FoodDetailScreens(food: food.toMap(), type: 'all_foods'),
   ),
 );
                    },
                    child:
                     Card(
                      color: Colors.grey.shade900, 
                      margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(food.imageUrl, height: 150, width: double.infinity, fit: BoxFit.cover),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                        
                        
                              children: [
                                Text(food.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                SizedBox(height: 5),
                                Text(food.description, style: TextStyle(color: Colors.white70)),
                                SizedBox(height: 5),
                                Text("₹ ${food.price.toStringAsFixed(2)}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error loading food items")),
      ),
    );
  }
}