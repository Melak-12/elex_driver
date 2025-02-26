import 'package:flutter/material.dart';

class FoodDeliveryPage extends StatelessWidget {
  const FoodDeliveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text("Food Delivery"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: const Center(
        child: Text(
          "Delicious food delivered to your doorstep!",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
