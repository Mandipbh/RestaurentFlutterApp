import 'package:flutter/material.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/screens/reserve_table/table_confirm_success.dart';
import 'package:restaurent/widgets/custom_sizebox.dart';

class ConfirmedTable extends StatelessWidget {
  final String restaurantName;
  final String date;
  final String time;
  final int numberOfPeople;

  const ConfirmedTable({
    Key? key,
    required this.restaurantName,
    required this.date,
    required this.time,
    required this.numberOfPeople,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF3c3c41),
      ),
      backgroundColor: const Color(0xFF3c3c41),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40),
            child: Text(
              "Confirm reservation?",
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          CustomSizedBox.h20,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow("Restaurant", restaurantName),
                const Divider(color: Color(0xFF414146)),
                _buildDetailRow("Date", date),
                const Divider(color: Color(0xFF414146)),
                _buildDetailRow("Time", time),
                const Divider(color: Color(0xFF414146)),
                _buildDetailRow("No of seats", numberOfPeople.toString()),
                const Divider(color: Color(0xFF414146)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Image.asset(
                'assets/select_category/nos_tables.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Spacer(),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.only(top: 24, bottom: 24),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 51, 50, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ConfirmedTableSuccess()),
                  );
                },
                child: const Text(
                  "CONFIRM RESERVATION",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
