import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/constants/responsive.dart';
import 'package:restaurent/constants/strings.dart';
import 'package:restaurent/providers/auth_provider.dart';
import 'package:restaurent/providers/reserved_table.dart';
import 'package:restaurent/screens/reserve_table/select_restaurant.dart';
import 'package:restaurent/screens/reserve_table/widgets/reserved_cart.dart';
import 'package:restaurent/widgets/custom_sizebox.dart';
import 'package:restaurent/widgets/custom_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddReserveTable extends ConsumerStatefulWidget {
  const AddReserveTable({super.key});

  @override
  ConsumerState<AddReserveTable> createState() => _AddReserveTableState();
}

class _AddReserveTableState extends ConsumerState<AddReserveTable> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(reservationsProvider.notifier).fetchReservations());
  }

  @override
  Widget build(BuildContext context) {
    final reservations = ref.watch(reservationsProvider);
    final user = ref.read(authProvider);
    final userName = user?.userMetadata?['full_name'] ?? 'Guest';

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: ScreenSize.height(context) * 0.12,
              ),
              Positioned(
                top: 40,
                left: 10,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new,
                      color: AppColors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Positioned(
                top: 40,
                left: 300,
                child: IconButton(
                  icon:
                      Icon(Icons.location_on, color: AppColors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Positioned(
                top: 40,
                left: 345,
                child: IconButton(
                  icon: Icon(Icons.notifications,
                      color: AppColors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),

          // Bottom Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
            decoration: const BoxDecoration(
              color: AppColors.black,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text: Strings.hello + userName,
                    fontSize: 16,
                    color: AppColors.white54,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: reservations.isNotEmpty
                      ? CustomText(
                          text: Strings.your_reservations,
                          fontSize: 32,
                          color: AppColors.white,
                        )
                      : null,
                ),
                CustomSizedBox.h20,
                reservations.isEmpty
                    ? CustomText(
                        text: Strings.no_res_yet,
                        fontSize: 24,
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      )
                    : SizedBox(
                        height: ScreenSize.height(context) * 0.65,
                        width: double.infinity,
                        child: ListView.builder(
                            itemCount: reservations.length,
                            itemBuilder: (context, index) {
                              final reservation = reservations[index];
                              return CartItemCard(
                                restaurantName:
                                    reservation['restaurant_name'] ?? '',
                                date: DateTime.parse(reservation['date']),
                                time: reservation['time'],
                                seat: reservation['no_of_people'],
                                table: List<int>.from(reservation['table_no']),
                                editOnTap: () async {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SelectRestaurant(
                                              reservations: [reservation],
                                            )),
                                  );
                                  await updateReservation(
                                      reservation['restaurant_id']);
                                },
                              );
                            }),
                      ),
                CustomSizedBox.h20,
                FloatingActionButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectRestaurant()),
                      );
                    },
                    backgroundColor: AppColors.add_reserve_color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(Icons.add, color: AppColors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateReservation(String restaurantId) async {
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('reservation_table')
        .delete()
        .match({'restaurant_id': restaurantId});

    if (response.error != null) {
      print("Error deleting reservation: ${response.error!.message}");
    } else {
      print("Reservation deleted successfully");
    }
  }
}
