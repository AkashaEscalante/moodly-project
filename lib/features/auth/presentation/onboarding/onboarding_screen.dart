import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moodly/features/auth/presentation/onboarding/step_one.dart';
import 'package:moodly/features/auth/presentation/onboarding/step_two.dart';
import 'package:moodly/features/auth/presentation/onboarding/step_three.dart';
import 'package:moodly/features/auth/presentation/onboarding/step_four.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (page) => setState(() => _currentPage = page),
        children: const [StepOne(), StepTwo(), StepThree(), StepFour()],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentPage > 0)
              TextButton(
                onPressed: () => _controller.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
                child: const Text('Back'),
              )
            else
              const SizedBox(),
            TextButton(
              onPressed: _nextOrFinish,
              child: Text(_currentPage == 3 ? 'Finish' : 'Next'),
            ),
          ],
        ),
      ),
    );
  }

  void _nextOrFinish() {
    if (_currentPage < 3) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/home');
    }
  }
}
