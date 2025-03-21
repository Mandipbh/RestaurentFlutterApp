import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/providers/city_restaurent_provider.dart'
    show cityProvider, restaurantProvider, selectedCityProvider, searchProvider;
import 'package:restaurent/screens/navigation/main-navigation.dart';
import 'package:restaurent/screens/restaurent/restaurent_food.dart';

class RestaurentScreen extends ConsumerWidget {
  const RestaurentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cityList = ref.watch(cityProvider);
    final selectedCity = ref.watch(selectedCityProvider);
    final restaurantList = ref.watch(restaurantProvider);
    final searchQuery = ref.watch(searchProvider);

    return Scaffold(
      appBar: AppBar(
        title:
            Text("Find Restaurants", style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => MainNavigation())),
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Select City", style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: cityList.when(
              data: (cities) => SizedBox(
                height: 50,
                child: ListView.builder(
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
                              color: isSelected ? Colors.white : Colors.white70,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              loading: () => Center(
                  child: CircularProgressIndicator(
                color: Colors.orange,
              )),
              error: (err, _) => Center(
                  child: Text("Error loading cities",
                      style: TextStyle(color: Colors.white))),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: restaurantList.when(
              data: (restaurants) {
                final filteredRestaurants = restaurants
                    .where((r) => r.name
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                    .toList();

                if (filteredRestaurants.isEmpty) {
                  return Center(
                      child: Text("No restaurants found",
                          style: TextStyle(color: Colors.white)));
                }

                return GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithAdaptiveCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.88,
                  ),
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
                      child: SizedBox(
                        child: Card(
                          color: Colors.grey.shade900,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 10,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10)),
                                    child: Image.network(
                                      restaurant.imageUrl,
                                      width: double.infinity,
                                      height: constraints.maxHeight * 0.5,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        height: constraints.maxHeight * 0.5,
                                        color: Colors.grey[300],
                                        child: Center(child: Icon(Icons.broken_image, size: 50)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          restaurant.name,
                                          style: TextStyle(
                                            fontSize: constraints.maxWidth * 0.07,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          restaurant.location ?? "No location available",
                                          style: TextStyle(
                                            fontSize: constraints.maxWidth * 0.05,
                                            color: Colors.white70,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => Center(
                  child: CircularProgressIndicator(
                color: Colors.orange,
              )),
              error: (err, _) => Center(
                  child: Text("Error loading restaurants",
                      style: TextStyle(color: Colors.white))),
            ),
          ),
        ],
      ),
    );
  }
}
