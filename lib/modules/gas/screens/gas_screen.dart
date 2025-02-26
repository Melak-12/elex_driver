import 'package:flutter/material.dart';

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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
