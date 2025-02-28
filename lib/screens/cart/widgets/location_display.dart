import 'package:flutter/material.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/widgets/custom_sizebox.dart';
import 'package:restaurent/widgets/custom_text.dart';

class LocationDisplay extends StatelessWidget {
  final String location;
  final VoidCallback? onEdit;

  const LocationDisplay({
    super.key,
    required this.location,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on_outlined, color: Colors.white),
        CustomSizedBox.w10,
        SizedBox(
          width: 180,
          child: CustomText(
            text: location,
            fontSize: 14,
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        // CustomSizedBox.w30,
        // IconButton(
          // icon: Icon(Icons.edit, color: AppColors.white70),
          // iconSize: 20,
          // onPressed: onEdit ?? () {},
        // ),
      ],
    );
  }
}
