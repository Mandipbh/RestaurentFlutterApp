import 'package:flutter/material.dart';
import 'package:restaurent/constants/images.dart';
import 'package:restaurent/constants/strings.dart';
import 'package:restaurent/screens/authentication/login.screen.dart';















class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'title': Strings.onboarding1Title,
      'subtitle': Strings.onboarding1Subtitle,
      'image1': Images.onboarding1,
      'image2': Images.onboarding2,
    },
    {
      'title': Strings.onboarding2Title,
      'subtitle': Strings.onboarding2Subtitle,
      'image1': Images.onboarding1,
      'image2': Images.onboarding2,
    },
    {
      'title': Strings.onboarding3Title,
      'subtitle': Strings.onboarding3Subtitle,
      'image1': Images.onboarding1,
      'image2': Images.onboarding2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return OnboardingPage(
                  title: onboardingData[index]['title']!,
                  subtitle: onboardingData[index]['subtitle']!,
                  image1: onboardingData[index]['image1']!,
                  image2: onboardingData[index]['image2']!,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _currentIndex < onboardingData.length - 1
                      ? () {
                          _pageController.jumpToPage(onboardingData.length - 1);
                        }
                      : null, // Disable the button on the last screen
                  child: _currentIndex < onboardingData.length - 1
                      ? Text(
                          "Skip",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        )
                      : SizedBox(), // Hide the button on the last screen
                ),

                // Row(
                //   children: List.generate(
                //     onboardingData.length,
                //     (index) => Container(
                //       margin: EdgeInsets.symmetric(horizontal: 4),
                //       width: _currentIndex == index ? 12 : 8,
                //       height: 8,
                //       decoration: BoxDecoration(
                //         color:
                //             _currentIndex == index ? Colors.white : Colors.grey,
                //         shape: BoxShape.circle,
                //       ),
                //     ),
                //   ),
                // ),
                ElevatedButton(
                  onPressed: () {
                    if (_currentIndex < onboardingData.length - 1) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(20),
                    backgroundColor: Colors.grey.shade900,
                  ),
                  child: Icon(Icons.arrow_forward_ios, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title, subtitle, image1, image2;

  const OnboardingPage(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.image1,
      required this.image2});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 90,
                right: -120,
                child: Transform.rotate(
                  angle: 0.5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      image2,
                      width: 300,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 180,
                left: -60,
                child: Transform.rotate(
                  angle: -0.3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      image1,
                      width: 350,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 150),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 350,
                child: Text(
                  subtitle,
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
