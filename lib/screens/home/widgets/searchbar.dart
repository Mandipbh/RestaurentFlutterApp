import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/providers/search_provider.dart';

class SearchBarWidget extends ConsumerWidget {
  final TextEditingController? controller;
  final String hintText;
  final Color backgroundColor;
  final Color hintTextColor;
  final Color iconColor;
  final double iconSize;
  final EdgeInsets padding;
  final EdgeInsets contentPadding;
  final Color textColor;

  const SearchBarWidget({
    super.key,
    this.controller,
    this.hintText = "",
    this.backgroundColor = AppColors.searchbarbackgroundcolor,
    this.hintTextColor = AppColors.white60,
    this.iconColor = AppColors.white,
    this.iconSize = 25.0,
    this.padding = const EdgeInsets.all(10),
    this.contentPadding = const EdgeInsets.only(left: 20, right: 50),
    this.textColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context , WidgetRef ref) {
        final searchQuery = ref.watch(searchQueryProvider);

    return Padding(
      padding: padding,
      child: TextField(
        controller: controller,
        style: TextStyle(color: textColor),
          onChanged: (value) {
          ref.read(searchQueryProvider.notifier).state = value;
        },
        decoration: InputDecoration(
          contentPadding: contentPadding,
          filled: true,
          fillColor: backgroundColor,
          suffixIcon: Icon(
            Icons.search,
            color: iconColor,
            size: iconSize,
          ),
          hintText: hintText.isEmpty ? "Search food items..." : hintText,
          hintStyle: TextStyle(color: hintTextColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          
        ),
      ),
    );
  }
}
