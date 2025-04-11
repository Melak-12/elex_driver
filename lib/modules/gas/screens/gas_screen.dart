import 'package:flutter/material.dart';
import 'package:elex_driver/core/constants/text_styles.dart';

class GasDeliveryPage extends StatelessWidget {
  const GasDeliveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text("Gas Cylinder Delivery"),
        backgroundColor: Colors.blueAccent,
      ),
      body: const Center(
        child: Text(
          "Reliable gas delivery at your service!",
          style: AppTextStyles.headline2,
        ),
      ),
    );
  }
}
