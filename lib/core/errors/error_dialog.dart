import 'package:elex_driver/core/constants/colors/colors.dart';
import 'package:elex_driver/core/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final IconData icon;

  const ErrorDialog({
    super.key,
    this.title = 'Error',
    this.message = 'An error occurred',
    this.buttonText = 'OK',
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      backgroundColor: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.red, // Error icon in red
              size: 50,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.headline2.copyWith(
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyText1,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary, // Red button
                  foregroundColor: Colors.white, // White text
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  buttonText,
                  style: AppTextStyles.buttonText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
