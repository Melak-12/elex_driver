import 'package:elex_driver/core/constants/colors/colors.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
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
              _buildOnboardingPage(
                  "assets/images/foods.png", "Reliable Gas Cylinder Delivery"),
              _buildOnboardingPage(
                  "assets/images/12.png", "Secure Document Delivery"),
            ],
          ),
          Positioned(
            top: 50,
            right: 20,
            child: _currentPage < 2
                ? TextButton(
                    onPressed: _skip,
                    child: const Text(
                      "Skip",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
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
                  onPressed: _currentPage == 2 ? _finishOnboarding : _nextPage,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(
                    _currentPage == 2 ? "Get Started" : "Next",
                    style: const TextStyle(
                        fontSize: 18, color: AppColors.secondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(String imagePath, String text) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: _currentPage == index ? 12 : 8,
      height: _currentPage == index ? 12 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppColors.primary : AppColors.secondary,
        shape: BoxShape.circle,
      ),
    );
  }

  void _finishOnboarding() {
    // Navigator.pushReplacementNamed(context, '/layout');
    Navigator.pushReplacementNamed(context, '/login');

  }
}
