import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/constants/strings.dart';
import 'package:restaurent/screens/reserve_table/add_reserve_table.dart';
import 'package:restaurent/widgets/custom_text.dart';

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
          backgroundColor: Colors.black,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Success",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Your table is reserved",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                Lottie.asset(
                  'assets/splash/success.json',
                  width: 200,
                  height: 200,
                  repeat: false,
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddReserveTable()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade900,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Back to Reserved List",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // bottomNavigationBar: Container(
          //   width: 300,
          //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          //   child: SizedBox(
          //     width: double.infinity,
          //     child: ElevatedButton(
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: Colors.grey.shade900,
          //         padding: EdgeInsets.symmetric(vertical: 16),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(12),
          //         ),
          //       ),
          //       onPressed: () {
          //       },
          //       child: CustomText(
          //         text: Strings.next,
          //         color: AppColors.white,
          //         fontSize: 16,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
        ));
  }
}
 