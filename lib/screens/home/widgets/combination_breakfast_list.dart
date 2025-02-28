import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/providers/cart_provider.dart';
import 'package:restaurent/screens/order_food/food_detail_screen.dart';
import 'package:restaurent/widgets/custom_sizebox.dart';
import 'package:restaurent/widgets/custom_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CombinationBreakfastList extends ConsumerWidget {
  final AsyncValue<List<dynamic>> breakfastAsync;
  final User user;

  const CombinationBreakfastList({super.key, required this.breakfastAsync, required this.user,});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
        final cart = ref.watch(cartProvider); 

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        height: 400,
        child: breakfastAsync.when(
          data: (foodItems) => ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              final food = foodItems[index];
                final isInCart =
      cart.any((item) => item['combination_breakfast_id'] == food['id']);
              return InkWell(
                onTap: (){
                      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FoodDetailScreens(food: food,type : 'combination'),
      ),
    );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          food['image_url'],
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 90,
                            height: 90,
                            color: Colors.grey[800],
                            child: Icon(Icons.image, color: Colors.white54),
                          ),
                        ),
                      ),
                      CustomSizedBox.w10,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: food['name'],
                              fontSize: 16,
                              color: AppColors.white,
                            ),
                            Row(
                              children: [
                                Icon(Icons.king_bed, color: Colors.grey, size: 20),
                                CustomSizedBox.w4,
                                CustomText(
                                  text:                         '${food['fat_grams']} kcal',
                
                                  fontSize: 12,
                                  color: AppColors.white70,
                                ),
                                CustomSizedBox.w10,
                                Icon(Icons.label, color: Colors.grey, size: 20),
                                CustomSizedBox.w4,
                                CustomText(
                                  text: '${food['carbs_grams']} grams',
                                  fontSize: 12,
                                  color: AppColors.white70,
                                ),
                              ],
                            ),
                            CustomSizedBox.h4,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                    text: '₹${food['price']}',
                                    fontSize: 16,
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold),
                               
                                 InkWell(
                    onTap: () {
                      if (!isInCart) {
                        ref
                            .read(cartProvider.notifier)
                            .addToCart(user.id, combinationBreakfastId: food['id'],  quantity: 1);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isInCart
                            ? Colors.orange
                            : Colors.grey.shade800,
                        borderRadius: BorderRadius.all(
                            Radius.circular(10.0)),
                      ),
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.add,
                        color: isInCart
                            ? Colors.white
                            : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                               
                               
                               
                               
                               
                               
                               
                              ],
                            ),
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
          error: (err, stack) => Center(child: Text("Error: $err")),
        ),
      ),
    );
  }
}
