import 'package:flutter/material.dart';

class MyImageScreen extends StatelessWidget {
  final String imageUrl;

  MyImageScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Screen'),
      ),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}
