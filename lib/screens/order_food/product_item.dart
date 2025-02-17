import 'package:flutter/material.dart';

class CategoryFilter extends StatefulWidget {
  final List<String> categories;
  final Function(String) onSelected;

  CategoryFilter({required this.categories, required this.onSelected});

  @override
  _CategoryFilterState createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<CategoryFilter> {
  int selectedIndex = 0; // Default selected index

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onSelected(widget.categories[index]);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.categories[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white60,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  if (isSelected)
                    Container(
                      height: 3,
                      width: 30,
                      color: Colors.red, // Red underline
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
