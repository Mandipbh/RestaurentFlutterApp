import 'package:flutter/material.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/constants/images.dart';
import 'package:restaurent/constants/strings.dart';
import 'package:restaurent/screens/navigation/main-navigation.dart';
import 'package:restaurent/screens/reserve_table/add_reserve_table.dart';
import 'package:restaurent/widgets/custom_sizebox.dart';
import 'package:restaurent/widgets/custom_text.dart';

class ReserveTable extends StatefulWidget {
  @override
  _ReserveTableState createState() => _ReserveTableState();
}

class _ReserveTableState extends State<ReserveTable>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();

    // Animation Controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);

    // Moving Up and Down Animation
    _iconAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainNavigation()));
        return false;
      },
      child: Scaffold(
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
                onVerticalDragEnd: (details) {
                  if (details.primaryVelocity! < -100) {
                    // Swipe Up Detected
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddReserveTable()),
                    );
                  }
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
                        color: AppColors.white70),
                    CustomSizedBox.h15,

                    // Animated Icon
                    AnimatedBuilder(
                      animation: _iconAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, -_iconAnimation.value),
                          child: Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.white,
                            size: 32,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
