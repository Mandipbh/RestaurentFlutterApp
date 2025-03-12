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
    print('location->>$location');
    return Row(
      children: [
        Icon(Icons.location_on_outlined, color: Colors.white),
        CustomSizedBox.w10,
        Expanded(
          child: CustomText(
            text: location.trim(),
            fontSize: 14,
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
