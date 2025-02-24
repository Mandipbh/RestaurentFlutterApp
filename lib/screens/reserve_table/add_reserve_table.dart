import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/providers/auth_provider.dart';
import 'package:restaurent/providers/reserved_table.dart';
import 'package:restaurent/screens/reserve_table/select_restaurant.dart';
import 'package:restaurent/screens/reserve_table/widgets/reserved_cart.dart';

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
    print('reservationsFromRiverpod $reservations');
    final user = ref.read(authProvider);
    final userName = user?.userMetadata?['full_name'] ?? 'Guest';

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/select_category/add_reserve_table.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 10,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new,
                      color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Positioned(
                top: 40,
                left: 300,
                child: IconButton(
                  icon: Icon(Icons.location_on, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Positioned(
                top: 40,
                left: 345,
                child: IconButton(
                  icon:
                      Icon(Icons.notifications, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),

          // Bottom Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Hello, $userName",
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Your Reservations",
                    style: TextStyle(color: AppColors.white, fontSize: 32),
                  ),
                ),
                reservations.isEmpty
                    ? const Text(
                        "No reservations yet",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : SizedBox(
                        height: 230,
                        width: double.infinity,
                        child: ListView.builder(
                            itemCount: reservations.length,
                            itemBuilder: (context, index) {
                              final reservation = reservations[index];
                              print('reservationList: $reservation');
                              return CartItemCard(
                                restaurantName:
                                    reservation['restaurant_name'] ??
                                        'Name Null',
                                // date: formattedDate,
                                date: DateTime.parse(reservation['date']) ??
                                    DateTime.now(),
                                time: reservation['time'] ?? 7,
                                seat: reservation['nos_of_people'] ?? 6,
                                table: 3,
                              );
                            }),
                      ),
                const SizedBox(height: 20),
                FloatingActionButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectRestaurant()),
                      );
                    },
                    backgroundColor: Color(0xFF2E2E2E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(Icons.add, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
