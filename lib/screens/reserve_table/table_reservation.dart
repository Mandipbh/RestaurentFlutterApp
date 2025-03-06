import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/constants/strings.dart';
import 'package:restaurent/model/city.dart';
import 'package:restaurent/providers/auth_provider.dart';
import 'package:restaurent/screens/payment/table_selection.dart';
import 'package:restaurent/widgets/custom_sizebox.dart';
import 'package:restaurent/widgets/custom_text.dart';

class TableReservationSelection extends ConsumerStatefulWidget {
  final String selectedRestaurantId;
  final String selectedRestaurantName;
  final City? selectedCity;
  final List<Map<String, dynamic>>? reservations;

  const TableReservationSelection({
    required this.selectedRestaurantId,
    required this.selectedRestaurantName,
    Key? key,
    this.reservations,
    this.selectedCity,
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
  List<int> peopleCount = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

  bool get isNextEnabled =>
      selectedDate != null && selectedTime != null && selectedPeople != null;

  @override
  void initState() {
    super.initState();
    generateCurrentWeek();

    if (widget.reservations != null && widget.reservations!.isNotEmpty) {
      var reservation = widget.reservations!.first;

      DateTime parsedReservationDate = DateTime.parse(reservation['date']);
      DateTime dateOnly = DateTime(parsedReservationDate.year,
          parsedReservationDate.month, parsedReservationDate.day);

      selectedDate = dateOnly.millisecondsSinceEpoch;
      selectedTime = reservation['time'];
      selectedPeople = reservation['no_of_people'];
      globalParsedDate = dateOnly;

      // Ensure selectedDate is unique
      if (!dates.contains(selectedDate)) {
        dates.add(selectedDate!);
        dates = dates.toSet().toList(); // Remove duplicates
        dates.sort();
      }
    }
  }

  void generateCurrentWeek() {
    setState(() {
      dates = List.generate(7, (index) {
        DateTime date = DateTime.now().add(Duration(days: index));
        return DateTime(date.year, date.month, date.day)
            .millisecondsSinceEpoch; // Store only the date without time
      }).toSet().toList(); // Ensure uniqueness

      dates.sort();

      if (selectedDate != null && !dates.contains(selectedDate)) {
        dates.add(selectedDate!);
        dates = dates.toSet().toList(); // Ensure uniqueness again
        dates.sort();
      }
    });
  }

  List<String> getAvailableTimes() {
    if (selectedDate == null) return times;

    DateTime selectedDateTime =
        DateTime.fromMillisecondsSinceEpoch(selectedDate!);
    DateTime now = DateTime.now();

    if (selectedDateTime.year == now.year &&
        selectedDateTime.month == now.month &&
        selectedDateTime.day == now.day) {
      return times.where((time) {
        DateTime parsedTime = DateFormat('h:mm a').parse(time);
        DateTime fullDateTime = DateTime(
            now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);
        return fullDateTime.isAfter(now);
      }).toList();
    }

    return times;
  }

  DateTime? globalParsedDate;

  @override
  Widget build(BuildContext context) {
    print('reservationsTableReservation ${widget.reservations}');
    final user = ref.read(authProvider);
    final userName = user?.userMetadata?['full_name'] ?? 'Guest';

    //Only showing single date which is selecting
    // List<int> dates = widget.reservations!
    //     .map((reservation) =>
    //         DateTime.parse(reservation['date']).millisecondsSinceEpoch)
    //     .toSet()
    //     .toList()
    //   ..sort();

    return WillPopScope(
      onWillPop: () async {
        if (widget.reservations!.isNotEmpty) {
          bool exit = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text("Pending"),
              content: Text("Please complete your selection."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("Cancel"),
                ),
                // TextButton(
                //   onPressed: () => Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(builder: (context) => ReserveTable()),
                //   ),
                //   child: Text("Go to Reserve Table"),
                // ),
              ],
            ),
          );
          return exit ?? false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.location_on, color: Colors.white),
                        CustomSizedBox.w10,
                        Icon(Icons.notifications, color: Colors.white),
                      ],
                    ),
                  ),

                  /// Scrollable Section
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0, right: 20, left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                                text: Strings.hello + userName,
                                fontSize: 16,
                                color: AppColors.white),
                            CustomSizedBox.h10,

                            CustomText(
                                text: Strings.res_table_at +
                                    widget.selectedRestaurantName,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white),
                            CustomSizedBox.h20,

                            // Select Date
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                    text: Strings.sel_date_res,
                                    color: AppColors.white,
                                    fontSize: 16),
                                GestureDetector(
                                  onTap: generateCurrentWeek,
                                  child: CustomText(
                                      text:
                                          '${DateFormat('MMM d').format(DateTime.now())} - ${DateFormat('MMM d').format(DateTime.now().add(Duration(days: 6)))}',
                                      color: AppColors.white,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            CustomSizedBox.h10,
                            buildSelectionRow<int>(dates, selectedDate, (val) {
                              DateTime parsedDate =
                                  DateTime.fromMillisecondsSinceEpoch(val);
                              print('selectedDateBefore $val');
                              setState(() {
                                selectedDate = val;
                                selectedTime = null;
                                globalParsedDate = parsedDate;
                              });
                              print('selectedDateAfter $selectedDate');
                            }, isDate: true),
                            CustomSizedBox.h20,
                            if (selectedDate != null) ...[
                              Text("Select the time",
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 10),
                              buildSelectionRow<String>(
                                  getAvailableTimes(), selectedTime, (val) {
                                setState(() => selectedTime = val);
                              }, isDate: false)
                            ],
                            CustomSizedBox.h20,
                            if (selectedTime != null) ...[
                              Text("Select the number of people",
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 10),
                              buildSelectionRow<int>(
                                  peopleCount, selectedPeople, (val) {
                                setState(() => selectedPeople = val);
                              }, isDate: false)
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),

                  //Next Button
                  if (isNextEnabled) ...[
                    Container(
                      width: 380,
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TableSelectionScreen(
                                  date: globalParsedDate,
                                  time: selectedTime,
                                  peopleCount: selectedPeople,
                                  restaurantId: widget.selectedRestaurantId,
                                  restaurantName: widget.selectedRestaurantName,
                                  city: widget.selectedCity?.name,
                                  reservations: widget.reservations,
                                ),
                              ),
                            );
                          },
                          child: CustomText(
                            text: Strings.next,
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSelectionRow<T>(
    List<T> items,
    T? selectedValue,
    Function(T) onSelect, {
    required bool isDate,
  }) {
    return SizedBox(
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          T item = items[index];
          bool isSelected = item == selectedValue;
          String displayText = item.toString();

          if (isDate && item is int) {
            DateTime date = DateTime.fromMillisecondsSinceEpoch(item);
            displayText = DateFormat('dd MMM yyyy').format(date);
          }

          return GestureDetector(
            onTap: () {
              onSelect(item);
            },
            child: Container(
              padding: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.red : AppColors.searchbgcolor800,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: CustomText(
                  text: displayText,
                  fontSize: 16,
                  color: AppColors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
