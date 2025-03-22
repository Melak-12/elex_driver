import 'package:elex_driver/core/constants/colors/colors.dart';
import 'package:elex_driver/core/constants/dimentsions.dart';
import 'package:elex_driver/core/constants/text_styles.dart';
import 'package:elex_driver/routes/app_router.dart';
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

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  void _finishOnboarding() {
    context.go(login);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.black.withOpacity(0.2),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.topRight,
                child: _currentPage < 2
                    ? TextButton(
                        onPressed: () => _pageController.jumpToPage(2),
                        child: const Text(
                          "Skip",
                          style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : const SizedBox(),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    _buildOnboardingPage(
                      "assets/images/gass 1.png",
                      "Cylinder Provider",
                      "Reliable and Timely Cylinder Supply",
                      "Ensure a steady and safe supply of cylinders with our efficient delivery service, guaranteeing they arrive securely and on time.",
                    ),
                    _buildOnboardingPage(
                      "assets/images/Document Delivery 1.png",
                      "Restaurant Food Delivery",
                      "Fresh, Fast, and Delicious",
                      "Enjoy your favorite meals delivered hot and on time with our reliable food delivery service satisfying your cravings, one bite at a time.",
                    ),
                    _buildOnboardingPage(
                      "assets/images/document 2.png",
                      "Document Delivery",
                      "Swift and Secure Delivery",
                      "Efficiently manage and send your documents with our seamless delivery service, ensuring they reach their destination safely and promptly.",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              // Navigation Buttons (Prev, Dots, Next)
              _buildNavigationButtons(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Onboarding Page UI
  Widget _buildOnboardingPage(
      String imagePath, String title, String subTitle, String description) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          title,
          style: AppTextStyles.headline1
              .copyWith(color: AppColors.primary, fontSize: 21),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Image.asset(
          imagePath,
          height: 320,
          width: screenWidth(context),
        ),
        const SizedBox(height: 20),
        Text(
          subTitle,
          style: AppTextStyles.headline1.copyWith(fontSize: 21),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            description,
            style: AppTextStyles.bodyText2,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  // Navigation Dots
  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: _currentPage == index ? 14 : 10,
      height: _currentPage == index ? 14 : 10,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppColors.primary2 : AppColors.secondary,
        shape: BoxShape.circle,
      ),
    );
  }

  // Navigation Buttons (Prev, Dots, Next/Get Started)
  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _currentPage > 0
            ? GestureDetector(
                onTap: _prevPage,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary2.withOpacity(0.2),
                  ),
                  child: const Icon(Icons.arrow_back, color: AppColors.primary2),
                ),
              )
            : const SizedBox(width: 50), 
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) => _buildDot(index)),
        ),

        _currentPage == 2
            ? ElevatedButton(
                onPressed: _finishOnboarding,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child:  Text(
                  "Get Started",
                  style: AppTextStyles.bodyText2.copyWith(color: Colors.white),
                ),
              )
            : GestureDetector(
                onTap: _nextPage,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary2.withOpacity(0.2),
                  ),
                  child: const Icon(Icons.arrow_forward, color: AppColors.primary2),
                ),
              ),
      ],
    );
  }

}
