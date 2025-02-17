import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class FlushbarUtils {
  static void showSuccessFlushbar(BuildContext context, String message) {
    Flushbar(
      messageText: Row(
        children: [
          Icon(Icons.check, color: Colors.white),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      duration: Duration(seconds: 4),
      backgroundColor: Colors.green.shade900,
      flushbarPosition: FlushbarPosition.TOP,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(10),
      padding: EdgeInsets.all(16),
      // icon: Icon(Icons.error_outline,
      //     color: Colors.white, size: 28), // Custom Icon
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 6,
          offset: Offset(2, 2),
        ),
      ], // Shadow effect
      leftBarIndicatorColor: Colors.white,
    ).show(context);
  }

  static void showErrorFlushbar(BuildContext context, String message) {
    Flushbar(
      messageText: Row(
        children: [
          Icon(Icons.error, color: Colors.white),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      duration: Duration(seconds: 4), // Display duration
      backgroundColor: Colors.red.shade900, // Custom Background Color
      flushbarPosition: FlushbarPosition.TOP, // Show at Top
      margin: EdgeInsets.symmetric(
          horizontal: 12, vertical: 8), // Margin for spacing
      borderRadius: BorderRadius.circular(10), // Rounded corners
      padding: EdgeInsets.all(16), // Padding inside the flushbar
      // icon: Icon(Icons.error_outline,
      //     color: Colors.white, size: 28), // Custom Icon
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 6,
          offset: Offset(2, 2),
        ),
      ], // Shadow effect
      leftBarIndicatorColor: Colors.white, // Left Indicator Color
    ).show(context);
  }
}
