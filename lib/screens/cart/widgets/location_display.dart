import 'package:flutter/material.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/widgets/custom_sizebox.dart';
import 'package:restaurent/widgets/custom_text.dart';

class LocationDisplay extends StatelessWidget {
  final String location;
  final VoidCallback? onEdit;

  const LocationDisplay({
    Key? key,
    required this.location,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on_outlined, color: Colors.white),
        CustomSizedBox.w10,
        CustomText(
          text: location,
          fontSize: 14,
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
        CustomSizedBox.w30,
        CustomSizedBox.w10,
        IconButton(
          icon: Icon(Icons.edit, color: AppColors.white70),
          iconSize: 20,
          onPressed: onEdit ?? () {},
        ),
      ],
    );
  }
}
