import 'package:flutter/material.dart';
import 'package:restaurent/screens/reserve_table/add_reserve_table.dart';

class ConfirmedTableSuccess extends StatelessWidget {
  const ConfirmedTableSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AddReserveTable()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF1C1C1E),
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Text(
                    "Success",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Your table is reserved",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 170),
                  Image.asset(
                    'assets/select_category/reserve_table_success.png',
                    fit: BoxFit.cover,
                  ),
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "NOTE: Reservation is only for 1 hour",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AddReserveTable()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
