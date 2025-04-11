import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart'; // Import the package
import 'package:elex_driver/common/custom_button.dart';
import 'package:elex_driver/core/constants/app_constants.dart';
import 'package:elex_driver/core/constants/colors/colors.dart';
import 'package:elex_driver/core/errors/error_dialog.dart';
import 'package:elex_driver/core/constants/text_styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final TextEditingController phoneEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Account Setup',
          style: TextStyle(
            color: AppColors.onSurfaceDark(context),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              IntlPhoneField(
                  controller: phoneEmailController,
                  decoration: InputDecoration(
                    labelText: 'Phone number',
                    filled: true,
                    fillColor: Colors.grey[100],
                    counter: const Offstage(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.phone,
                      color: AppColors.primary,
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.disabled,
                  initialCountryCode: 'ET'),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.grey[100],
                  counter: const Offstage(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1,
                    ),
                  ),
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: AppColors.primary,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.primary,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a password';
                  }
                  if ((value?.length ?? 0) < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppConstant.horizontalPadding),
                child: Text.rich(
                  TextSpan(
                    text:
                        'By proceeding, you consent to get calls or SMS messages, '
                        'including automated dialer, from ELEX and its affiliates to this number. '
                        'By proceeding you agree to ',
                    style: AppTextStyles.bodyText1,
                    children: [
                      TextSpan(
                        text: 'our terms of service',
                        style: AppTextStyles.bodyText2,
                      ),
                      TextSpan(
                        text: ' and ',
                        style: AppTextStyles.bodyText1,
                      ),
                      TextSpan(
                        text: 'privacy policy.',
                        style: AppTextStyles.bodyText2,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 35),
              SizedBox(
                child: CustomButton(
                  text: 'Log in',
                  onPressed: () {
                    if (phoneEmailController.text.isNotEmpty) {
                      context.push("/verify");
                      debugPrint(
                          'Logging in with: ${phoneEmailController.text}');
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => const ErrorDialog(
                          title: 'Error',
                          message: 'Please enter a valid phone number.',
                          buttonText: 'Done',
                        ),
                      );
                    }
                  },
                  borderRadius: 50.0,
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              // Signup Prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ",
                      style: TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  GestureDetector(
                    onTap: () {
                      // Get.toNamed('/signup');
                      context.push('/signup');
                    },
                    child: const Text(
                      'Signup',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.12),

              // OR Divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey.shade300,
                      thickness: 1,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'or',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey.shade300,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Sign in with Google
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
                child: OutlinedButton.icon(
                  icon: Image.asset(
                    'assets/images/google.png',
                    height: 24,
                    width: 24,
                  ),
                  label: const Text(
                    'Sign in with Google',
                    style: TextStyle(fontSize: 14, color: AppColors.black),
                  ),
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Sign in with Apple
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
                child: OutlinedButton.icon(
                  icon: Image.asset(
                    'assets/images/apple.png',
                    height: 24,
                    width: 24,
                  ),
                  label: const Text(
                    'Sign in with Apple',
                    style: TextStyle(fontSize: 14, color: AppColors.black),
                  ),
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
