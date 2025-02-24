import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gotrue/src/types/user.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/constants/strings.dart';
import 'package:restaurent/providers/cart_provider.dart';
import 'package:restaurent/screens/order_food/food_detail_screen.dart';
import 'package:restaurent/widgets/custom_sizebox.dart';
import 'package:restaurent/widgets/custom_text.dart';

class CategoryFoodList extends ConsumerWidget {
  final AsyncValue<List<Map<String, dynamic>>> categoryAsync;
  final AsyncValue<List<Map<String, dynamic>>> foodItems;
  final StateProvider<String?> selectedCategoryIdProvider;
  final User user;

  const CategoryFoodList({
    super.key,
    required this.categoryAsync,
    required this.foodItems,
    required this.selectedCategoryIdProvider,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);
    final cart = ref.watch(cartProvider); // Watch the cart state

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Categories List
        categoryAsync.when(
          data: (categories) {
            final categoryNames =
                categories.map((cat) => cat["name"] as String).toList();
            final categoryIds =
                categories.map((cat) => cat["id"] as String).toList();

            if (selectedCategoryId == null && categoryIds.isNotEmpty) {
              ref.read(selectedCategoryIdProvider.notifier).state =
                  categoryIds[0];
            }

            return SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryNames.length,
                itemBuilder: (context, index) {
                  final isSelected = categoryIds[index] == selectedCategoryId;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () {
                        ref.read(selectedCategoryIdProvider.notifier).state =
                            categoryIds[index];
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(
                              text: categoryNames[index],
                              fontSize: 16,
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.searchbgcolor400,
                              fontWeight: FontWeight.w500,
                            ),
                            CustomSizedBox.h4,
                            if (isSelected)
                              Container(
                                width: 0.7 * (categoryNames[index].length * 10),
                                height: 3,
                                decoration: BoxDecoration(
                                  color: AppColors.red,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stack) => CustomText(
              text: error.toString(), fontSize: 16, color: AppColors.white),
        ),
        CustomSizedBox.h35,

        // Food Items List
        foodItems.when(
          data: (foods) {
            if (foods.isEmpty) {
              return Center(
                child: CustomText(
                  text: Strings.noitems,
                  fontSize: 16,
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              );
            }

            return SizedBox(
              height: 230,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: foods.length,
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) {
                  final food = foods[index];

                  final isInCart =
                      cart.any((item) => item['food_id'] == food['id']);

                  return Container(
                    width: 170,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 58, 20, 6).withOpacity(0.7),
                          const Color.fromARGB(255, 58, 20, 6).withOpacity(0.7),
                          Colors.black.withOpacity(0.5),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FoodDetailScreens(food: food),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              food['image_url'] ?? '',
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                height: 140,
                                color: Colors.grey[800],
                                child: Icon(Icons.fastfood,
                                    color: Colors.grey[600]),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: food['name'] ?? '',
                                fontSize: 16,
                                color: AppColors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              CustomSizedBox.h4,
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.king_bed,
                                          color: AppColors.grey, size: 20),
                                      CustomText(
                                        text: '5 kcal',
                                        fontSize: 12,
                                        color: AppColors.white70,
                                        fontWeight: FontWeight.w500,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  CustomSizedBox.w10,
                                  Row(
                                    children: [
                                      Icon(Icons.label,
                                          color: Colors.grey, size: 20),
                                      CustomText(
                                        text: '300 gm',
                                        fontSize: 12,
                                        color: AppColors.white70,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                            .addToCart(user.id, food['id'], 1);
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isInCart
                                            ? Colors.orange
                                            : Colors.grey.shade900,
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
                  );
                },
              ),
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text("Error: $err")),
        ),
      ],
    );
  }
}
