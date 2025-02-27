import 'package:elex_driver/core/constants/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  void _skip() {
    _pageController.animateToPage(2,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.black.withOpacity(0.2),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildOnboardingPage(
                    "assets/images/11.png", "Fast & Hot Food Delivery"),
                _buildOnboardingPage("assets/images/foods.png",
                    "Reliable Gas Cylinder Delivery"),
                _buildOnboardingPage(
                    "assets/images/12.png", "Secure Document Delivery"),
              ],
            ),
            Positioned(
              top: 50,
              right: 20,
              child: _currentPage < 2
                  ? Row(
                      children: [
                        TextButton(
                          onPressed: _skip,
                          child: const Text(
                            "Skip",
                            style: TextStyle(
                                color: AppColors.primary, fontSize: 18),
                          ),
                        ),
                        const Icon(Icons.arrow_forward,
                            color: AppColors.primary),
                      ],
                    )
                  : const SizedBox(),
            ),
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) => _buildDot(index),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed:
                        _currentPage == 2 ? _finishOnboarding : _nextPage,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      backgroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(
                      _currentPage == 2 ? "Get Started" : "Next",
                      style: const TextStyle(
                          fontSize: 18, color: AppColors.primary),
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

  Widget _buildOnboardingPage(String imagePath, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(150),
              bottomRight: Radius.circular(150),
            ),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
            // color: Colors.black.withOpacity(0.5),
            //
          ),
          // child: Center(
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.circular(150),
          //     child: Image.asset(
          //       imagePath,
          //       // height: 200,
          //       // width: 200,
          //     ),
          //   ),)
        ),
        Expanded(
          // height: MediaQuery.of(context).size.height * 0.4,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    text,
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec eget felis ut nunc lacinia.",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: _currentPage == index ? 12 : 8,
      height: _currentPage == index ? 12 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppColors.secondary : Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  void _finishOnboarding() {
  
    context.go( '/login');
  }
}
