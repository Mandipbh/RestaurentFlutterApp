import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/constants/strings.dart';
import 'package:restaurent/model/reservation_table.dart';
import 'package:restaurent/providers/reserved_table.dart';
import 'package:restaurent/screens/reserve_table/confirm_table.dart';
import 'package:restaurent/widgets/custom_text.dart';

class TableSelectionScreen extends ConsumerStatefulWidget {
  final DateTime? date;
  final String? time;
  final int? peopleCount;
  final String? restaurantId;
  final String? restaurantName;
  final String? city;
  final List<Map<String, dynamic>>? reservations;
  const TableSelectionScreen(
      {super.key,
      required this.date,
      required this.time,
      required this.peopleCount,
      required this.restaurantId,
      required this.restaurantName,
      required this.city,
      required this.reservations});

  @override
  _TableSelectionScreenState createState() => _TableSelectionScreenState();
}

class _TableSelectionScreenState extends ConsumerState<TableSelectionScreen> {
  List<TableModel> tables = [
    TableModel(id: "1", seatCount: 4, isMerged: false),
    TableModel(id: "2", seatCount: 6, isMerged: false),
    TableModel(id: "3", seatCount: 4, isMerged: false),
    TableModel(id: "4", seatCount: 6, isMerged: false),
    TableModel(id: "5", seatCount: 4, isMerged: false),
    TableModel(id: "6", seatCount: 6, isMerged: false),
    TableModel(id: "7", seatCount: 4, isMerged: false),
    TableModel(id: "8", seatCount: 6, isMerged: false),
    TableModel(id: "9", seatCount: 4, isMerged: false),
    TableModel(id: "10", seatCount: 6, isMerged: false),
    TableModel(id: "11", seatCount: 2, isMerged: false),
    TableModel(id: "12", seatCount: 2, isMerged: false),
  ];

  String? selectedTableId;

  void mergeTables(String targetId, String draggedId) {
    setState(() {
      var targetTable = tables.firstWhere((table) => table.id == targetId);
      var draggedTable = tables.firstWhere((table) => table.id == draggedId);

      if (!targetTable.isMerged && !draggedTable.isMerged) {
        int newSeatCount = targetTable.seatCount + draggedTable.seatCount;
        if (newSeatCount <= 12) {
          targetTable.seatCount = newSeatCount;
          targetTable.isMerged = true;
          draggedTable.isMerged = true; // Mark both tables as merged
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Maximum seat count per table is 12!")),
          );
        }
      }
    });
  }

  void unmergeTable(String tableId) {
    setState(() {
      var table = tables.firstWhere((table) => table.id == tableId);
      if (table.isMerged) {
        // Find the original table that was merged
        var originalTable = TableModel(
            id: "temp",
            seatCount: table.seatCount - 2,
            isMerged: false); // Example logic
        tables.add(originalTable);
        table.isMerged = false;
        table.seatCount -= 2; // Adjust the seat count accordingly
      }
    });
  }

  void selectTable(String tableId) {
    setState(() {
      if (selectedTableId == tableId) {
        selectedTableId = null;
      } else {
        selectedTableId = tableId;
      }
    });
  }

  void bookTable(String tableId) {
    setState(() {
      var table = tables.firstWhere((table) => table.id == tableId);
      if (!table.isBooked) {
        table.isBooked = true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Table is already booked!")),
        );
      }
    });
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: CustomText(
            text: Strings.choose_table, fontSize: 22, color: AppColors.white),
        backgroundColor: AppColors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: GridView.builder(
                padding: EdgeInsets.all(20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: tables.length,
                itemBuilder: (context, index) {
                  return Draggable<String>(
                    data: tables[index].id,
                    feedback: Opacity(
                      opacity: 0.7,
                      child: buildTableBox(tables[index], true),
                    ),
                    childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: buildTableBox(tables[index], false)),
                    child: DragTarget<String>(
                      onWillAcceptWithDetails: (draggedId) =>
                          draggedId != tables[index].id,
                      onAcceptWithDetails: (details) =>
                          mergeTables(tables[index].id, details.data),
                      builder: (context, candidateData, rejectedData) {
                        return GestureDetector(
                          onTap: () {
                            if (!tables[index].isBooked) {
                              bookTable(tables[index].id);
                            }
                            selectTable(tables[index].id);
                          },
                          onLongPress: () {
                            if (tables[index].isMerged) {
                              unmergeTable(tables[index].id);
                            }
                          },
                          child: buildTableBox(tables[index],
                              selectedTableId == tables[index].id),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          if (selectedTableId != null || tables.any((table) => table.isMerged))
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
                    onPressed: () async {
                      List<int> selectedTableIds = [];
                      if (tables.any((table) => table.isMerged)) {
                        var mergedTables =
                            tables.where((table) => table.isMerged).toList();
                        selectedTableIds = mergedTables
                            .map((table) => int.parse(table.id))
                            .toList();
                      } else if (selectedTableId != null) {
                        selectedTableIds = [int.parse(selectedTableId!)];
                      }

                      await ref
                          .read(reservationsProvider.notifier)
                          .reserveTable(
                            cityName: widget.city,
                            restaurantId: widget.restaurantId,
                            restaurantName: widget.restaurantName,
                            date: widget.date,
                            time: widget.time,
                            peopleCount: widget.peopleCount,
                            selectedTableId: selectedTableIds,
                            isMerge: selectedTableIds.length > 1,
                          );

                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Table reserved successfully!')),
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConfirmedTable(
                            restaurantName: widget.restaurantName,
                            date: widget.date,
                            time: widget.time,
                            numberOfPeople: widget.peopleCount,
                            cityName: widget.city,
                          ),
                        ),
                      );
                    },
                    child: CustomText(
                      text: Strings.next,
                      fontSize: 16,
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildTableBox(TableModel table, bool isSelected) {
    int columns = table.seatCount <= 4
        ? 2
        : table.seatCount <= 6
            ? 3
            : table.seatCount <= 9
                ? 3
                : 4;

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: table.isBooked
            ? AppColors.red
            : (selectedTableId == table.id
                ? AppColors.blueAccent
                : AppColors.black),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 100,
            height: 60,
            decoration: BoxDecoration(
              color: table.isMerged
                  ? AppColors.orange_opc5
                  : AppColors.searchbgcolor900,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Center(
              child: CustomText(
            text: table.seatCount.toString(),
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          )),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Stack(
                children: List.generate(table.seatCount, (index) {
                  double offsetX = (index % columns) * 15.0;
                  double offsetY = (index ~/ columns) * 15.0;

                  return Positioned(
                    left: offsetX,
                    top: offsetY,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 2.0,
                            color: table.isMerged
                                ? AppColors.black
                                : AppColors.searchbgcolor800),
                        color: table.isMerged
                            ? AppColors.orange
                            : AppColors.searchbgcolor900,
                      ),
                      child: Center(
                          child: CustomText(
                              text: (index + 1).toString(),
                              fontSize: 12,
                              color: AppColors.white)),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
