import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/constants/images.dart';
import 'package:restaurent/constants/strings.dart';
import 'package:restaurent/widgets/custom_sizebox.dart';
import 'package:restaurent/widgets/custom_text.dart';

class CartItemCard extends StatelessWidget {
  final String restaurantName;
  final String? imageUrl;
  final DateTime date;
  final String time;
  final int seat;
  final List<int>? table;
  final void Function()? editOnTap;

  const CartItemCard({
    super.key,
    required this.restaurantName,
    this.imageUrl,
    required this.date,
    required this.time,
    required this.seat,
    this.table,
    this.editOnTap,
  });

  @override
  Widget build(BuildContext context) {
    // print('table->>> $table');
    String formattedDate = DateFormat('MMMM dd, yyyy').format(date);
    return Card(
      color: AppColors.card_color,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 20, bottom: 10, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: restaurantName,
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                InkWell(
                  onTap: editOnTap,
                  child: Icon(
                    Icons.edit,
                    color: AppColors.white60,
                    size: 20,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  Image.asset(
                    Images.reserve_table_no,
                    fit: BoxFit.cover,
                    width: 80,
                    height: 80,
                  ),
                  CustomSizedBox.w30,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomSizedBox.h4,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: Strings.date,
                              color: AppColors.grey,
                              fontSize: 14,
                            ),
                            CustomText(
                              text: formattedDate,
                              color: AppColors.grey,
                              fontSize: 14,
                            ),
                          ],
                        ),
                        CustomSizedBox.h4,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: Strings.time,
                              color: AppColors.grey,
                              fontSize: 14,
                            ),
                            CustomText(
                              text: time,
                              color: AppColors.grey,
                              fontSize: 14,
                            ),
                          ],
                        ),
                        CustomSizedBox.h4,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: Strings.seat,
                              color: AppColors.grey,
                              fontSize: 14,
                            ),
                            CustomText(
                              text: seat.toString(),
                              color: AppColors.grey,
                              fontSize: 14,
                            ),
                          ],
                        ),
                        CustomSizedBox.h4,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: Strings.table,
                              color: AppColors.grey,
                              fontSize: 14,
                            ),
                            CustomText(
                              text: table?.toString() ?? 'N/A',
                              color: AppColors.grey,
                              fontSize: 14,
                            ),
                          ],
                        ),
                        CustomSizedBox.h4,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
