import 'package:flutter/material.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PromoBannerWidget extends StatelessWidget {
  final PageController _pageController = PageController();
  final List<String> imagePaths;

  PromoBannerWidget({super.key, required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            height: 200,
            child: PageView(
              controller: _pageController,
              children: imagePaths
                  .map((imagePath) => _buildPromoCard(imagePath))
                  .toList(),
            ),
          ),
        ),
        _buildPageIndicator(),
      ],
    );
  }

  Widget _buildPromoCard(String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Center(
        child: SmoothPageIndicator(
          controller: _pageController,
          count: imagePaths.length,
          effect: const ScrollingDotsEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: AppColors.white,
            dotColor: AppColors.grey,
          ),
        ),
      ),
    );
  }
}
