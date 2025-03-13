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

  void _skip() {
    _pageController.jumpToPage(2);
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
                        onPressed: _skip,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) => _buildDot(index)),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _currentPage == 2 ? _finishOnboarding : _nextPage,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: AppColors.primary2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    _currentPage == 2 ? "Get Started" : "Learn More",
                    style: AppTextStyles.buttonText,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            description,
            style: AppTextStyles.bodyText2,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

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

  void _finishOnboarding() {
    context.go(login);
  }
}
