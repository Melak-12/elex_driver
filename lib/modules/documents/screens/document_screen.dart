import 'package:flutter/material.dart';

class DocumentDeliveryPage extends StatelessWidget {
  const DocumentDeliveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text("Document Delivery"),
        backgroundColor: Colors.greenAccent,
      ),
      body: const Center(
        child: Text(
          "Secure and fast document delivery!",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
