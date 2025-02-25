import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/model/city.dart';
import 'package:restaurent/model/restaurants.dart';
import 'package:restaurent/providers/city_provider.dart';
import 'package:restaurent/screens/reserve_table/table_reservation.dart';

final selectedRestaurantIdProvider = StateProvider<String?>((ref) => null);

class SelectRestaurant extends ConsumerStatefulWidget {
  @override
  _SelectRestaurantState createState() => _SelectRestaurantState();
}

class _SelectRestaurantState extends ConsumerState<SelectRestaurant> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(selectedCityIdProvider.notifier).state = null;
      ref.read(selectedRestaurantIdProvider.notifier).state = null;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    final cityList = ref.watch(cityProvider);
    final selectedCityId = ref.watch(selectedCityIdProvider);
    final restaurantList = ref.watch(restaurantListProvider(selectedCityId));
    final selectedRestaurantId = ref.watch(selectedRestaurantIdProvider);
    print('selectedRestaurantId $selectedRestaurantId'); // pass to next screen

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text(
                    "Select the restaurant",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text("Select your city",
                  style: TextStyle(color: Colors.white, fontSize: 14)),
              SizedBox(height: 10),

              cityList.when(
                loading: () => Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                    child: Text("Error loading cities",
                        style: TextStyle(color: Colors.red))),
                data: (cities) => SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: cities.length,
                    itemBuilder: (context, index) {
                      final city = cities[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: cityButton(ref, city),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Display Restaurants
              Expanded(
                child: restaurantList.when(
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(
                      child: Text("Error loading restaurants",
                          style: TextStyle(color: Colors.red))),
                  data: (restaurants) {
                    if (restaurants.isEmpty) {
                      return Center(
                        child: Text("No restaurants found",
                            style: TextStyle(color: Colors.white)),
                      );
                    }

                    return ListView.builder(
                      itemCount: restaurants.length,
                      itemBuilder: (context, index) {
                        final restaurant = restaurants[index];
                        return restaurantCard(ref, restaurant);
                      },
                    );
                  },
                ),
              ),

              // Show Button When a Restaurant is Selected
              if (selectedRestaurantId != null) ...[
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade900,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      // onPressed: () {
                      //   Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             TableReservationSelection()),
                      //   );
                      // },
                      onPressed: () {
                        if (selectedRestaurantId != null) {
                          final selectedRestaurant = restaurantList.maybeWhen(
                              data: (restaurants) {
                                return restaurants.firstWhere((restaurant) =>
                                    restaurant.id == selectedRestaurantId);
                              },
                              orElse: () => null);

                          if (selectedRestaurant != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TableReservationSelection(
                                  selectedRestaurantId: selectedRestaurant.id,
                                  selectedRestaurantName:
                                      selectedRestaurant.name,
                                ),
                              ),
                            );
                          }
                        }
                      },

                      child: Text(
                        'NEXT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // City Selection Button
  Widget cityButton(WidgetRef ref, City city) {
    final selectedCityId = ref.watch(selectedCityIdProvider);
    return GestureDetector(
      onTap: () {
        ref.read(selectedCityIdProvider.notifier).state = city.id;
        ref.read(selectedRestaurantIdProvider.notifier).state =
            null; // Reset selection when city changes
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: selectedCityId == city.id ? Colors.red : Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(city.name,
            style: TextStyle(color: Colors.white, fontSize: 14)),
      ),
    );
  }

  // Restaurant Card with Selection
  Widget restaurantCard(WidgetRef ref, Restaurant restaurant) {
    print('restaurantName ${restaurant.name}');
    final selectedRestaurantId = ref.watch(selectedRestaurantIdProvider);
    final isSelected = selectedRestaurantId == restaurant.id;

    return GestureDetector(
      onTap: () {
        ref.read(selectedRestaurantIdProvider.notifier).state = restaurant.id;
      },
      child: Card(
        color: isSelected ? Colors.red[900] : Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Restaurant Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  restaurant.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey,
                      child: Icon(Icons.image, color: Colors.white),
                    );
                  },
                ),
              ),
              SizedBox(width: 12),
              // Restaurant Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      restaurant.address,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
