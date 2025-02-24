import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:restaurent/providers/auth_provider.dart';
import 'package:restaurent/screens/reserve_table/confirm_table.dart';

class TableReservationSelection extends ConsumerStatefulWidget {
  final String selectedRestaurantId;
  final String selectedRestaurantName;

  const TableReservationSelection({
    required this.selectedRestaurantId,
    required this.selectedRestaurantName,
    Key? key,
  }) : super(key: key);

  @override
  _TableReservationSelectionState createState() =>
      _TableReservationSelectionState();
}

class _TableReservationSelectionState
    extends ConsumerState<TableReservationSelection> {
  int? selectedDate;
  String? selectedTime;
  int? selectedPeople;

  List<int> dates = [];
  List<String> times = ['6:00 PM', '7:00 PM', '8:00 PM', '9:00 PM'];
  List<int> peopleCount = [1, 2, 3, 4, 5, 6];

  bool get isNextEnabled =>
      selectedDate != null && selectedTime != null && selectedPeople != null;

  @override
  void initState() {
    super.initState();
    generateCurrentWeek(); // Generate dates when screen loads
  }

  void generateCurrentWeek() {
    setState(() {
      dates = List.generate(7, (index) {
        return DateTime.now().add(Duration(days: index)).day;
      });
    });
  }

  bool isLoading = false;

  Future<void> reserveTable() async {
    try {
      setState(() => isLoading = true);
      final user = ref.watch(authProvider);
      final userMetadata = user?.userMetadata;
      print('userMetadata: $userMetadata');
      final userId = userMetadata?['sub'];
      final userName = userMetadata?['full_name'];
      print('userData: userId: $userId, userName: $userName');

      DateTime reservationDate = DateTime.now().copyWith(day: selectedDate!);
      String formattedDate = DateFormat('yyyy-MM-dd').format(reservationDate);

      await supabase.from('reservation_table').insert({
        'restaurant_id': widget.selectedRestaurantId,
        'restaurant_name': widget.selectedRestaurantName,
        'user_id': userId,
        'user_name': userName,
        'date': formattedDate,
        'time': selectedTime,
        'no_of_people': selectedPeople,
        'table_no': 3,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Table reserved successfully!')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmedTable(
            restaurantName: widget.selectedRestaurantName,
            date: formattedDate,
            time: selectedTime!,
            numberOfPeople: selectedPeople!,
          ),
        ),
      );
    } catch (error) {
      print('Insertion error: $error');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('selectedRestaurantIdAnotherScreen ${widget.selectedRestaurantId}');
    print(
        'selectedRestaurantNameAnotherScreen ${widget.selectedRestaurantName}');
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// Background Image
          Positioned.fill(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.38,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/select_category/add_reserve_table.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Scrollable Content
          SafeArea(
            child: Column(
              children: [
                /// Top Icons
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.location_on, color: Colors.white),
                      SizedBox(width: 10),
                      Icon(Icons.notifications, color: Colors.white),
                    ],
                  ),
                ),

                /// Scrollable Section
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 80.0, right: 20, left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Spacer for the image
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4),

                          /// Welcome Text
                          Text(
                            "Hello username!",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Reserve a table\nat Paragon",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),

                          // Select Date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Select the date for reservation",
                                  style: TextStyle(color: Colors.white)),
                              GestureDetector(
                                onTap: generateCurrentWeek,
                                child: Text(
                                  "${DateFormat('MMM d').format(DateTime.now())} - ${DateFormat('MMM d').format(DateTime.now().add(Duration(days: 6)))}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          buildSelectionRow<int>(dates, selectedDate, (val) {
                            setState(() => selectedDate = val);
                          }, isDate: true),

                          SizedBox(height: 20),

                          // Select Time
                          if (selectedDate != null) ...[
                            Text("Select the time",
                                style: TextStyle(color: Colors.white)),
                            SizedBox(height: 10),
                            buildSelectionRow<String>(times, selectedTime,
                                (val) {
                              setState(() => selectedTime = val);
                            }, isDate: false),
                          ],

                          SizedBox(height: 20),

                          /// Select Number of People
                          if (selectedTime != null) ...[
                            Text("Select the number of people",
                                style: TextStyle(color: Colors.white)),
                            SizedBox(height: 10),
                            buildSelectionRow<int>(peopleCount, selectedPeople,
                                (val) {
                              setState(() => selectedPeople = val);
                            }, isDate: false),
                          ],

                          SizedBox(height: 30),

                          /// NEXT Button
                          if (isNextEnabled)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 24),
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
                                    reserveTable();
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
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSelectionRow<T>(
      List<T> items, T? selectedValue, Function(T) onSelect,
      {required bool isDate}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((item) {
          bool isSelected = item == selectedValue;

          // Convert `item` to a date and get the day name
          String? dayName;
          if (isDate && item is int) {
            DateTime date =
                DateTime.now().add(Duration(days: item - DateTime.now().day));
            dayName = DateFormat('EEE').format(date); // Gets short day name
          }

          return GestureDetector(
            onTap: () => onSelect(item),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.red : Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    "$item",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  if (isDate && dayName != null)
                    Text(
                      dayName,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
