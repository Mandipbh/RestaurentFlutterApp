import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider(
      {super.key,
      required this.color,
      required this.thickness,
      required this.indent,
      required this.endIndent});

  final Color color;
  final double thickness;
  final double indent;
  final double endIndent;

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
