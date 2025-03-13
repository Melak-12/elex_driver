import 'package:elex_driver/core/constants/colors/colors.dart';
import 'package:elex_driver/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // animation duration
      vsync: this,
    );

    // Define the wave expansion animation
    _animation = Tween<double>(begin: 0, end: 450).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )..addListener(() {
        setState(() {});
      });

    // Start the animation
    _controller.repeat(reverse: false);

    Future.delayed(const Duration(seconds: 2), () {
      // Use context.go() to navigate to the onboarding screen
      context.go(onBoarding); // Onboarding screen route
    });
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Dispose of the controller when the screen is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Circular Wave Animation
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(
                      _animation.value * 1,
                      _animation.value *
                          100), // Increase size based on animation value
                  painter: WavePainter(
                    // color1: ,
                    color2: Colors.white,
                    progress: _animation.value,
                  ),
                );
              },
            ),
            // Circular Logo Image in the center
            ClipRRect(
              borderRadius: BorderRadius.circular(
                  50), // Half of width and height to make it circular
              child: Image.asset(
                'assets/images/Logo mark2.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  // final Color color1;
  final Color color2;
  final double progress;

  WavePainter({
    // required this.color1,
    required this.color2,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Paint paint1 = Paint()
    //   ..color = color1.withOpacity(0.6)
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 100;
    Paint paint2 = Paint()
      ..color = color2
      ..style = PaintingStyle.stroke
      ..strokeWidth = 100;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), progress * 1.5, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Redraw when animation changes
  }
}
