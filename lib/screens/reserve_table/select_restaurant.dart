import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/constants/strings.dart';
import 'package:restaurent/model/city.dart';
import 'package:restaurent/model/restaurants.dart';
import 'package:restaurent/providers/city_provider.dart';
import 'package:restaurent/screens/reserve_table/table_reservation.dart';
import 'package:restaurent/widgets/custom_sizebox.dart';
import 'package:restaurent/widgets/custom_text.dart';

final selectedRestaurantIdProvider = StateProvider<String?>((ref) => null);

class SelectRestaurant extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>>? reservations;

  const SelectRestaurant({Key? key, this.reservations}) : super(key: key);

  @override
  _SelectRestaurantState createState() => _SelectRestaurantState();
}

class _SelectRestaurantState extends ConsumerState<SelectRestaurant> {
  String? selectedCityId;
  Map<String, dynamic>? selectedRestaurant;
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

    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, color: AppColors.white, size: 24),
                  CustomSizedBox.w8,
                  CustomText(
                      text: Strings.select_res,
                      fontSize: 20,
                      color: AppColors.white)
                ],
              ),
              CustomSizedBox.h20,
              CustomText(
                  text: Strings.select_city,
                  fontSize: 14,
                  color: AppColors.white),
              CustomSizedBox.h10,

              cityList.when(
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(
                        child: CustomText(
                            text: Strings.error_load_city,
                            fontSize: 14,
                            color: AppColors.red),
                      ),
                  data: (cities) {
                    final selectedCityId = ref.watch(selectedCityIdProvider);

                    if (selectedCityId == null && widget.reservations != null) {
                      String? reservedCityName =
                          widget.reservations!.first['city_name'];

                      final defaultCity = cities.firstWhere(
                        (city) => city.name == reservedCityName,
                        orElse: () => City(
                            id: '', name: 'Unknown', state: '', country: ''),
                      );

                      if (defaultCity.id.isNotEmpty) {
                        Future.microtask(() {
                          ref.read(selectedCityIdProvider.notifier).state =
                              defaultCity.id;
                        });
                      }
                    }
                    return SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: cities.length,
                        itemBuilder: (context, index) {
                          final city = cities[index];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: cityButton(ref, city),
                          );
                        },
                      ),
                    );
                  }),

              CustomSizedBox.h20,

              Expanded(
                child: restaurantList.when(
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(
                    child: CustomText(
                        text: Strings.error_load_city,
                        fontSize: 14,
                        color: AppColors.red),
                  ),
                  data: (restaurants) {
                    if (restaurants.isEmpty) {
                      return Center(
                        child: CustomText(
                            text: Strings.error_load_restaurant,
                            fontSize: 14,
                            color: AppColors.white),
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
                CustomSizedBox.h20,
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
                        onPressed: () {
                          if (selectedRestaurantId != null) {
                            final selectedRestaurant = restaurantList.maybeWhen(
                                data: (restaurants) {
                                  return restaurants.firstWhere((restaurant) =>
                                      restaurant.id == selectedRestaurantId);
                                },
                                orElse: () => null);

                            if (selectedRestaurant != null) {
                              final selectedCity = cityList.maybeWhen(
                                data: (cities) {
                                  return cities.firstWhere(
                                      (city) => city.id == selectedCityId,
                                      orElse: () => City(
                                          id: '',
                                          name: 'Unknown',
                                          state: '',
                                          country: ''));
                                },
                                orElse: () => City(
                                    id: '',
                                    name: 'Unknown',
                                    state: '',
                                    country: ''),
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TableReservationSelection(
                                          selectedRestaurantId:
                                              selectedRestaurant.id,
                                          selectedRestaurantName:
                                              selectedRestaurant.name,
                                          selectedCity: selectedCity,
                                          reservations: widget.reservations),
                                ),
                              );
                            }
                          }
                        },
                        child: CustomText(
                          text: Strings.next,
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  } // City Selection Button

  Widget cityButton(WidgetRef ref, City city) {
    final selectedCityId = ref.watch(selectedCityIdProvider);
    return GestureDetector(
      onTap: () {
        ref.read(selectedCityIdProvider.notifier).state = city.id;
        ref.read(selectedRestaurantIdProvider.notifier).state = null;
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: selectedCityId == city.id
                ? AppColors.red
                : AppColors.searchbgcolor800,
            borderRadius: BorderRadius.circular(12),
          ),
          child: CustomText(
              text: city.name, fontSize: 14, color: AppColors.white)),
    );
  }

  // Restaurant Card with Selection
  Widget restaurantCard(WidgetRef ref, Restaurant restaurant) {
    final selectedRestaurantId = ref.watch(selectedRestaurantIdProvider);
    final isSelected = selectedRestaurantId == restaurant.id;

    return GestureDetector(
      onTap: () {
        ref.read(selectedRestaurantIdProvider.notifier).state = restaurant.id;
      },
      child: Card(
        color: isSelected ? AppColors.redish : AppColors.searchbgcolor900,
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
                      color: AppColors.grey,
                      child: Icon(Icons.image, color: AppColors.white),
                    );
                  },
                ),
              ),
              CustomSizedBox.w12,
              // Restaurant Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                        text: restaurant.name,
                        fontSize: 16,
                        color: AppColors.white),
                    CustomSizedBox.h4,
                    CustomText(
                        text: restaurant.address,
                        fontSize: 14,
                        color: AppColors.white),
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
