import 'dart:math';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
 appBar: AppBar(
   title:
       Text("Choose Table", style: TextStyle(color: AppColors.white)),
       
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
                child: buildTableBox(tables[index]),
              ),
              childWhenDragging: Opacity(opacity: 0.3, child: buildTableBox(tables[index])),
              child: DragTarget<String>(
                onWillAcceptWithDetails: (draggedId) => draggedId != tables[index].id,
                onAcceptWithDetails: (details) => mergeTables(tables[index].id, details.data),
                builder: (context, candidateData, rejectedData) {
                  return buildTableBox(tables[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildTableBox(TableModel table) {
  int columns = table.seatCount <= 4
      ? 2
      : table.seatCount <= 6
          ? 3
          : table.seatCount <= 9
              ? 3
              : 4; // Adjusts grid columns dynamically

  return Container(
    width: 120,
    height: 120,
    decoration: BoxDecoration(
      color: Colors.black,
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
        // Padding and circular seats
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


class TableWidget extends StatelessWidget {
  final int seatCount;
  final bool isMerged;

  const TableWidget({super.key, required this.seatCount, required this.isMerged});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Chairs (Half-circle layout)
        Positioned.fill(
          child: CustomPaint(
            painter: ChairPainter(seatCount, isMerged),
          ),
        ),

        // Table (Rectangle Box)
        Container(
          width: 100,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            seatCount.toString(),
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class ChairPainter extends CustomPainter {
  final int seatCount;
  final bool isMerged;

  ChairPainter(this.seatCount, this.isMerged);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = isMerged ? Colors.red : Colors.grey.shade900
      ..style = PaintingStyle.fill;

    final double tableWidth = 100;
    final double tableHeight = 60;
    final double radius = 12;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Half-circle positions for chairs
    for (int i = 0; i < seatCount; i++) {
      double angle = (i / (seatCount - 1)) * 3.14; // Spread across half-circle
      double x = centerX + (tableWidth / 1.5) * cos(angle) - radius;
      double y = centerY - (tableHeight / 1.2) * sin(angle) - radius;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class TableModel {
  String id;
  int seatCount;
  bool isMerged;

  TableModel({required this.id, required this.seatCount, this.isMerged = false});
}
