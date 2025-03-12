import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/providers/city_restaurent_provider.dart'
    show cityProvider, restaurantProvider, selectedCityProvider;
import 'package:restaurent/screens/navigation/main-navigation.dart';
import 'package:restaurent/screens/restaurent/restaurent_food.dart';
import 'dart:async';

// Search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');

class RestaurentScreen extends ConsumerStatefulWidget {
  const RestaurentScreen({super.key});

  @override
  ConsumerState<RestaurentScreen> createState() => _RestaurentScreenState();
}

class _RestaurentScreenState extends ConsumerState<RestaurentScreen> {
  late TextEditingController searchController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(
      text: ref.read(searchQueryProvider),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 300), () {
      ref.read(searchQueryProvider.notifier).state = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cityList = ref.watch(cityProvider);
    final selectedCity = ref.watch(selectedCityProvider);
    final restaurantList = ref.watch(restaurantProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurants", style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => MainNavigation())),
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // City Selection List
          SizedBox(
            height: 60,
            child: cityList.when(
              data: (cities) => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  final city = cities[index];
                  final isSelected = selectedCity?.id == city.id;

                  return GestureDetector(
                    onTap: () =>
                        ref.read(selectedCityProvider.notifier).state = city,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? Colors.orange : Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          city.name,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              loading: () => CircularProgressIndicator(),
              error: (err, _) => Text("Error loading cities"),
            ),
          ),

          SizedBox(height: 16),

          // Search Bar with Smooth Searching
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: searchController,
              onChanged: _onSearchChanged,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search restaurants...",
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          SizedBox(height: 16),

          // Restaurant List
          Expanded(
            child: restaurantList.when(
              data: (restaurants) {
                // Filter restaurants based on search query
                final filteredRestaurants = restaurants
                    .where((restaurant) => restaurant.name
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                    .toList();

                if (filteredRestaurants.isEmpty) {
                  return Center(
                    child: Text("No restaurants found",
                        style: TextStyle(color: AppColors.white)),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: filteredRestaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = filteredRestaurants[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FoodListScreen(restaurantId: restaurant.id),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.grey.shade900,
                        margin: EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Restaurant Image
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10)),
                              child: Image.network(
                                restaurant.imageUrl,
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  height: 180,
                                  color: Colors.grey[300],
                                  child: Center(
                                      child:
                                          Icon(Icons.broken_image, size: 50)),
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Restaurant Name
                                  Text(
                                    restaurant.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),

                                  SizedBox(height: 6),

                                  // Restaurant Location
                                  Text(
                                    restaurant.location ??
                                        "No description available",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  SizedBox(height: 10),

                                  // Location & Ratings Row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Location Icon + City Name
                                      Row(
                                        children: [
                                          Icon(Icons.location_on,
                                              color: Colors.red, size: 18),
                                          SizedBox(width: 5),
                                          Text(
                                            restaurant.cityName,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),

                                      // Ratings
                                      Row(
                                        children: [
                                          Icon(Icons.star,
                                              color: Colors.orange, size: 18),
                                          SizedBox(width: 5),
                                          Text(
                                            restaurant.rating
                                                    .toStringAsFixed(1) ??
                                                "N/A",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ],
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
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (err, _) =>
                  Center(child: Text("Error loading restaurants")),
            ),
          ),
        ],
      ),
    );
  }
}
