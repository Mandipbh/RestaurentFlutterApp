import 'package:flutter/material.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/screens/order_food/offer_detail_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PromoBannerWidget extends StatelessWidget {
  final PageController _pageController = PageController();
  final List<Map<String, String>> offers = [
    {
      "image": "assets/splash/offer1.jpeg",
      "title": "50% Off on First Order!",
      "description": "Enjoy 50% discount on your first order. Limited time offer!"
    },
    {
      "image": "assets/splash/offer2.jpg",
      "title": "Free Dessert with Main Course!",
      "description": "Order a main course and get a free dessert. Offer valid today only!"
    },
    {
      "image": "assets/splash/offer3.jpeg",
      "title": "Buy 1 Get 1 Free Pizza!",
      "description": "Order any pizza and get another one for free. Available for dine-in only."
    },
  ];

  PromoBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              itemCount: offers.length,
              itemBuilder: (context, index) {
                return _buildPromoCard(context, offers[index]);
              },
            ),
          ),
        ),
        _buildPageIndicator(),
      ],
    );
  }

  Widget _buildPromoCard(BuildContext context, Map<String, String> offer) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OfferDetailScreen(
              title: offer["title"]!,
              description: offer["description"]!,
              imagePath: offer["image"]!,
            ),
          ),
        );
      },
      child: Hero(
        tag: offer["image"]!,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(offer["image"]!),
              fit: BoxFit.cover,
            ),
          ),
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
          count: offers.length,
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
