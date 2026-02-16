import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const StepIndicator({
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalSteps,
        (index) {
          final isActive = index == currentStep;
          
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 3),
            height: 3,
            width: 20,
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.white
                  : Colors.grey.shade500,
              borderRadius: BorderRadius.circular(1.5),
            ),
          );
        },
      ),
    );
  }
}