import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/providers/food_provider.dart';
import 'package:restaurent/screens/order_food/food_detail_screen.dart';

class FoodListScreen extends ConsumerStatefulWidget {
  final String restaurantId;
  const FoodListScreen({super.key, required this.restaurantId});

  @override
  _FoodListScreenState createState() => _FoodListScreenState();
}

class _FoodListScreenState extends ConsumerState<FoodListScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<String> bannerImages = [
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTS6cVa2mWoZt5XwR0w7XoEBqMGz5GMzaufqA&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ-qX9uFIOOxZ8ZxpzPsbf5R-64_wE0tDF7yQ&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1at1AQqKFipOmgCQBtvavh5jHxTM5BhVHZg&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSHokhc35HIVOyBktNDtuASkYxDmRiNz3XdgA&s"
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < bannerImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foodList = ref.watch(foodItemsProvider(widget.restaurantId));

    return Scaffold(
      appBar: AppBar(
        title: Text("Foods", style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Banner Section
          // SizedBox(
            // height: 250,
            // child: Stack(
              // alignment: Alignment.bottomCenter,
              // children: [
                // PageView.builder(
                  // controller: _pageController,
                  // itemCount: bannerImages.length,
                  // onPageChanged: (index) {
                    // setState(() {
                      // _currentPage = index;
                    // });
                  // },
                  // itemBuilder: (context, index) {
                    // return AnimatedContainer(
                      // duration: Duration(milliseconds: 500),
                      // curve: Curves.easeInOut,
                      // child: ClipRRect(
                        // borderRadius: BorderRadius.circular(15),
                        // child: Image.network(
                          // bannerImages[index],
                          // fit: BoxFit.cover,
                          // width: double.infinity,
                        // ),
                      // ),
                    // );
                  // },
                // ),
                // Positioned(
                  // bottom: 10,
                  // child: SmoothPageIndicator(
                    // controller: _pageController,
                    // count: bannerImages.length,
                    // effect: ExpandingDotsEffect(
                      // activeDotColor: Colors.orange,
                      // dotColor: Colors.grey.shade600,
                      // dotHeight: 8,
                      // dotWidth: 8,
                      // expansionFactor: 3,
                    // ),
                  // ),
                // ),
              // ],
            // ),
          // ),
          SizedBox(height: 10),

          // Food List
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double cardWidth = (constraints.maxWidth / 2) - 16; // Adjust for padding
                double cardHeight = cardWidth * 1.2; // Adjust aspect ratio dynamically

                return foodList.when(
                  data: (foods) => foods.isEmpty
                      ? Center(child: Text("No food available", style: TextStyle(color: Colors.white)))
                      : GridView.builder(
                          padding: EdgeInsets.all(10),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: constraints.maxWidth > 600 ? 3 : 2, // 3 columns for larger screens
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: cardWidth / cardHeight,
                          ),
                          itemCount: foods.length,
                          itemBuilder: (context, index) {
                            final food = foods[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration: Duration(milliseconds: 500),
                                    pageBuilder: (_, __, ___) =>
                                        FoodDetailScreens(food: food.toMap(), type: 'all_foods'),
                                    transitionsBuilder: (_, animation, __, child) {
                                      return FadeTransition(opacity: animation, child: child);
                                    },
                                  ),
                                );
                              },
                              child: Card(
                                color: Colors.grey.shade900,
                                elevation: 5,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Hero(
                                      tag: food.imageUrl,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                        child: Image.network(
                                          food.imageUrl,
                                          height: cardWidth * 0.58, // Adjust image height
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            food.name,
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            food.description,
                                            style: TextStyle(color: Colors.white70, fontSize: 12),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            "₹ ${food.price.toStringAsFixed(2)}",
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
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
                  loading: () => Center(child: CircularProgressIndicator(color: Colors.orange)),
                  error: (err, _) => Center(child: Text("Error loading food items", style: TextStyle(color: Colors.white))),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}