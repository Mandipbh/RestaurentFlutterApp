import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.color,
    this.onTap,
    this.fontWeight,
    this.textAlign,
  });

  final String text;
  final double fontSize;
  final Color color;
  final Function()? onTap;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
          ),
          textAlign: textAlign,
        ));
  }
}
