import 'package:flutter/material.dart';

class ClothingRecommendationPage extends StatelessWidget {
  const ClothingRecommendationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clothing Recommendation')),
      body: Center(
        child: Text('Recommended Clothes for You', style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}
