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
    this.maxLines,
    this.overflow,
    this.width,
  });

  final String text;
  final double fontSize;
  final Color color;
  final Function()? onTap;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? width; // Made width optional

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: width, // Optional width constraint
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
          ),
          textAlign: textAlign,
          maxLines: maxLines, // Optional maxLines
          overflow: overflow, // Optional overflow
        ),
      ),
    );
  }
}