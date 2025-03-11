import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/providers/cart_provider.dart';
import 'package:restaurent/providers/search_provider.dart';
import 'package:restaurent/screens/order_food/food_detail_screen.dart';
import 'package:restaurent/widgets/custom_sizebox.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecommendedFoodList extends ConsumerWidget {
  final AsyncValue<List<dynamic>> recommendedAsync;
  final User user;

  const RecommendedFoodList(
      {super.key, required this.recommendedAsync, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return SizedBox(
      height: 283,
      child: recommendedAsync.when(
        data: (foodItems) {
          if (foodItems.isEmpty) {
            return Center(
                child: Text('No recommended items available',
                    style: TextStyle(color: Colors.white)));
          }

          // Filter recommended items based on search query
          final filteredItems = foodItems
              .where(
                  (food) => matchesSearchQuery(food['name'] ?? '', searchQuery))
              .toList();

          if (filteredItems.isEmpty && searchQuery.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                  child: Text('No matching recommended items found',
                      style: TextStyle(color: Colors.white))),
            );
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              final food = filteredItems[index];
              final isInCart = cart.any(
                  (item) => item['recommended_breakfast_id'] == food['id']);
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FoodDetailScreens(
                        food: food,
                        type: 'recommended_breakfast',
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipOval(
                            child: Container(
                              width: 120,
                              height: 120,
                              color: Colors.transparent,
                              child: Image.network(
                                food['image_url'],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  width: 120,
                                  height: 120,
                                  color: Colors.grey[800],
                                  child:
                                      Icon(Icons.image, color: Colors.white54),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      CustomSizedBox.h10,
                      Text(
                        food['name'],
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      CustomSizedBox.h8,
                      Text(
                        '₹${food['price']}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      CustomSizedBox.h13,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.king_bed, color: Colors.grey, size: 20),
                          CustomSizedBox.w4,
                          Text(
                            '${food['fat_grams']} kcal',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                          CustomSizedBox.w10,
                          Icon(Icons.label, color: Colors.grey, size: 20),
                          CustomSizedBox.w4,
                          Text(
                            '${food['carbs_grams']} grams',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      CustomSizedBox.h15,
                      InkWell(
                        onTap: () {
                          if (!isInCart) {
                            ref.read(cartProvider.notifier).addToCart(user.id,
                                recommendedBreakfastId: food['id'],
                                quantity: 1);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                isInCart ? Colors.orange : Colors.grey.shade800,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.add,
                            color: isInCart ? Colors.white : Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => Offstage(),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }
}
