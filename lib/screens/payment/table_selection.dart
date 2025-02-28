import 'package:flutter/material.dart';
import 'package:restaurent/constants/colors.dart';

class TableSelectionScreen extends StatefulWidget {
  const TableSelectionScreen({super.key});

  @override
  _TableSelectionScreenState createState() => _TableSelectionScreenState();
}

class _TableSelectionScreenState extends State<TableSelectionScreen> {
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
          tables.remove(draggedTable);
        } else {
          // Show error if seat count exceeds 12
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
        var originalTable = TableModel(id: "temp", seatCount: table.seatCount - 2, isMerged: false); // Example logic
        tables.add(originalTable);
        table.isMerged = false;
        table.seatCount -= 2; // Adjust the seat count accordingly
      }
    });
  }

  void selectTable(String tableId) {
    setState(() {
      selectedTableId = tableId;
    });
  }

  void bookTable(String tableId) {
    setState(() {
      var table = tables.firstWhere((table) => table.id == tableId);
      if (!table.isBooked) {
        table.isBooked = true; // Mark the table as booked
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Table is already booked!")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Choose Table", style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
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
              childWhenDragging: Opacity(opacity: 0.3, child: buildTableBox(tables[index], false)),
              child: DragTarget<String>(
                onWillAcceptWithDetails: (draggedId) => draggedId != tables[index].id,
                onAcceptWithDetails: (details) => mergeTables(tables[index].id, details.data),
                builder: (context, candidateData, rejectedData) {
                  return GestureDetector(
                    onTap: () {
                      if (!tables[index].isBooked) {
                        bookTable(tables[index].id); // Book the table on tap
                      }
                    },
                    onLongPress: () {
                      if (tables[index].isMerged) {
                        unmergeTable(tables[index].id); // Unmerge the table on long press
                      }
                    },
                    child: buildTableBox(tables[index], selectedTableId == tables[index].id),
                  );
                },
              ),
            );
          },
        ),
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
        color: table.isBooked ? Colors.red : (isSelected ? Colors.blueAccent : Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 100,
            height: 60,
            decoration: BoxDecoration(
              color: table.isMerged ? Colors.orange.withOpacity(0.5) : Colors.grey.shade900,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Center(
            child: Text(
              table.seatCount.toString(),
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Stack(
                children: List.generate(table.seatCount, (index) {
                  double offsetX = (index % columns) * 15.0; // Horizontal offset
                  double offsetY = (index ~/ columns) * 15.0; // Vertical offset

                  return Positioned(
                    left: offsetX,
                    top: offsetY,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2.0, color: table.isMerged ? Colors.black : Colors.grey.shade800),
                        color: table.isMerged ? Colors.orange : Colors.grey.shade900,
                      ),
                      child: Center(
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
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

class TableModel {
  String id;
  int seatCount;
  bool isMerged;
  bool isBooked; // New property to track booking status

  TableModel({required this.id, required this.seatCount, this.isMerged = false, this.isBooked = false});
}