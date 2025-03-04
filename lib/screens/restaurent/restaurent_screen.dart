import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/providers/city_restaurent_provider.dart' show cityProvider, restaurantProvider, selectedCityProvider;
import 'package:restaurent/screens/navigation/main-navigation.dart';
import 'package:restaurent/screens/restaurent/restaurent_food.dart';


class RestaurentScreen extends ConsumerWidget {
  const RestaurentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cityList = ref.watch(cityProvider);
    final selectedCity = ref.watch(selectedCityProvider);
    final restaurantList = ref.watch(restaurantProvider);

    return Scaffold(
  appBar: AppBar(
    title:
        Text("Restaurents", style: TextStyle(color: AppColors.white)),
    backgroundColor: AppColors.black,
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainNavigation())),
    ),
  ),
  backgroundColor: Colors.black,    
    body: Column(
        children: [
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

                    onTap: () => ref.read(selectedCityProvider.notifier).state = city,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.orange : Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          city.name,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white,
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

     Expanded(
  child: restaurantList.when(
    data: (restaurants) => restaurants.isEmpty
        ? Center(child: Text("No restaurants available"))
        : ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];

              return GestureDetector(
                onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => FoodListScreen(restaurantId: restaurant.id),
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
                        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                        child: Image.network(
                          restaurant.imageUrl,  // Ensure your Restaurant model has this
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 180,
                            color: Colors.grey[300],
                            child: Center(child: Icon(Icons.broken_image, size: 50)),
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
                                color: Colors.white
                              ),
                            ),
                
                            SizedBox(height: 6),
                
                            // Restaurant Description (if available)
                            Text(
                              restaurant.location ?? "No description available",
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Location Icon + City Name
                                Row(
                                  children: [
                                    Icon(Icons.location_on, color: Colors.red, size: 18),
                                    SizedBox(width: 5),
                                    Text(
                                      restaurant.cityName,
                                      style: TextStyle(fontSize: 14, color: Colors.white),
                                    ),
                                  ],
                                ),
                
                                // Ratings (if available)
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.orange, size: 18),
                                    SizedBox(width: 5),
                                    Text(
                                      restaurant.rating.toStringAsFixed(1) ?? "N/A",
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.white),
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
          ),
    loading: () => Center(child: CircularProgressIndicator()),
    error: (err, _) => Center(child: Text("Error loading restaurants")),
  ),
),
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
        ],
      ),
    );
  }
}