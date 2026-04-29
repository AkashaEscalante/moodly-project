import 'package:flutter/material.dart';

class StepOne extends StatelessWidget {
  const StepOne({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Welcome to Moodly'),
          Text('Track your mood and improve your wellbeing'),
        ],
      ),
    );
  }
}
