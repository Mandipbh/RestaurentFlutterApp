import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/widgets/custom_sizebox.dart';

class RecommendedFoodList extends StatelessWidget {
  final AsyncValue<List<dynamic>> recommendedAsync;

  const RecommendedFoodList({Key? key, required this.recommendedAsync})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 283,
      child: recommendedAsync.when(
        data: (foodItems) => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: foodItems.length,
          itemBuilder: (context, index) {
            final food = foodItems[index];
            print('Food---> $food');

            return Container(
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
                              child: Icon(Icons.image, color: Colors.white54),
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
                    // '₹${food['price']}',
                    '₹24',
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
                        '5 kcal',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      CustomSizedBox.w10,
                      Icon(Icons.label, color: Colors.grey, size: 20),
                      CustomSizedBox.w4,
                      Text(
                        '300 gm',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  CustomSizedBox.h15,
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Color(0xFF2E2E2E),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ],
              ),
            );
          },
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }
}
