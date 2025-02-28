import 'package:flutter/material.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/constants/images.dart';
import 'package:restaurent/constants/strings.dart';
import 'package:restaurent/screens/reserve_table/add_reserve_table.dart';
import 'package:restaurent/widgets/custom_sizebox.dart';
import 'package:restaurent/widgets/custom_text.dart';

class ReserveTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            Images.reserve_table_bg,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.linearG1, AppColors.linearG2],
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddReserveTable()),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                     text: Strings.reserve_table_text,
                    fontSize: 24,
                    color: AppColors.white,
                     fontWeight: FontWeight.bold,
                  ),
                  CustomSizedBox.h8,
                   CustomText(
                    text: Strings.reserve_table_desc,
                    fontSize: 16,
                    color: AppColors.white70
                  ),
                 CustomSizedBox.h15,
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 32,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
