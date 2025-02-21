import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/widgets/custom_sizebox.dart';
import 'package:restaurent/widgets/custom_text.dart';

class CombinationBreakfastList extends StatelessWidget {
  final AsyncValue<List<dynamic>> breakfastAsync;

  const CombinationBreakfastList({Key? key, required this.breakfastAsync})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              return Container(
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
                                text: '5 kcal',
                                fontSize: 12,
                                color: AppColors.white70,
                              ),
                              CustomSizedBox.w10,
                              Icon(Icons.label, color: Colors.grey, size: 20),
                              CustomSizedBox.w4,
                              CustomText(
                                text: '300 gm',
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
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Color(0xFF2E2E2E),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Icon(Icons.add,
                                    color: Colors.white, size: 20),
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
          loading: () => Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text("Error: $err")),
        ),
      ),
    );
  }
}
