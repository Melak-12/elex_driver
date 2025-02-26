import 'package:elex_driver/common/custom_button.dart';
import 'package:elex_driver/core/errors/error_dialog.dart';
import 'package:elex_driver/modules/auth/providers/verify_provider.dart';
import 'package:elex_driver/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// import 'verify_provider.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  // Create controllers for each text field
  final List<TextEditingController> _controllers = List.generate(
    5,
    (index) => TextEditingController(),
  );

  // Create focus nodes for each text field
  final List<FocusNode> _focusNodes = List.generate(
    5,
    (index) => FocusNode(),
  );

  @override
  void dispose() {
    // Dispose controllers and focus nodes to avoid memory leaks
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Add listeners to controllers and focus nodes
    for (int i = 0; i < 5; i++) {
      _controllers[i].addListener(() {
        final provider = Provider.of<VerifyProvider>(context, listen: false);
        provider.updateCodeDigit(i, _controllers[i].text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VerifyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Please Enter the verification number we sent to your number !',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                5,
                (index) => _buildDigitField(index, context),
              ),
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: 'Verify',
              onPressed: provider.isCodeComplete()
                  ? () => _onVerifyPressed(provider)
                  : () => showDialog(
                        context: context,
                        builder: (context) => const ErrorDialog(
                        title:  'Error',
                         message:  'Please enter a valid OTP number.',
                         buttonText:  'Done',
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDigitField(int index, BuildContext context) {
    return SizedBox(
      width: 50,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[100],
        ),
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          onChanged: (value) {
            // Move to next field if there is content and we're not at the last field
            if (value.isNotEmpty && index < 4) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            } else if (index == 4 && value.isNotEmpty) {
              // Last field, remove focus
              FocusScope.of(context).unfocus();
            }
          },
          // Handle backspace navigation using a custom input formatter
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _BackspaceNavigationFormatter(
              currentIndex: index,
              controllers: _controllers,
              focusNodes: _focusNodes,
              context: context,
            ),
          ],
          decoration: InputDecoration(
            counter: const SizedBox.shrink(),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  void _onVerifyPressed(VerifyProvider provider) {
    Navigator.pushNamedAndRemoveUntil(
        context, RouteManager.layout, (route) => false);
    // Get the complete verification code
    final verificationCode = provider.getFullCode();
    print(verificationCode);
  }
}

// Custom TextInputFormatter to handle backspace navigation
class _BackspaceNavigationFormatter extends TextInputFormatter {
  final int currentIndex;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final BuildContext context;

  _BackspaceNavigationFormatter({
    required this.currentIndex,
    required this.controllers,
    required this.focusNodes,
    required this.context,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // If text is being deleted and current field is empty
    if (oldValue.text.isNotEmpty && newValue.text.isEmpty && currentIndex > 0) {
      // Schedule moving focus to previous field (needs to be scheduled to avoid build conflicts)
      Future.microtask(() {
        FocusScope.of(context).requestFocus(focusNodes[currentIndex - 1]);
      });
    }
    return newValue;
  }
}
