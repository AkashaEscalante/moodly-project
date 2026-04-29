import 'package:flutter/material.dart';

class StepThree extends StatelessWidget {
  const StepThree({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Set daily reminder time'),
          Text('Stay consistent with your mood tracking'),
        ],
      ),
    );
  }
}
