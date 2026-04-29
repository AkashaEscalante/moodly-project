import 'package:flutter/material.dart';

class StepTwo extends StatelessWidget {
  const StepTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Choose your avatar'),
          Text('Personalize your profile'),
        ],
      ),
    );
  }
}
