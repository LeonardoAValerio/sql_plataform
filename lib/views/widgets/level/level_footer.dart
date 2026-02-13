import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sql_plataform/core/database/objectbox.g.dart';
import 'package:sql_plataform/core/database/objectbox_manager.dart';
import 'package:sql_plataform/models/level.dart';
import 'package:sql_plataform/viewmodels/level_viewmodel.dart';
import 'package:sql_plataform/views/widgets/level/step_indicator.dart';

class LevelFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LevelViewModel>();
    final chapter = viewModel.level.chapter.target!;

    return Container(
      padding: EdgeInsets.all(16),
      
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botão circular esquerda
          _CircularNavigationButton(
            icon: Icons.arrow_back_ios_new,
            onPressed: viewModel.isFirstStep ? null : viewModel.previousStep,
            backgroundColor: Color(chapter.color)
          ),
          
          // Indicador
          StepIndicator(
            totalSteps: viewModel.totalSteps,
            currentStep: viewModel.currentStepIndex,
          ),
          
          // Botão circular direita
          _CircularNavigationButton(
            icon: viewModel.isLastStep ? Icons.check : Icons.arrow_forward_ios,
            backgroundColor: Color(chapter.color),
            onPressed: viewModel.canProceed()
                ? () {
                    if (viewModel.isLastStep) {
                      _finishLevel(context, viewModel.level.refId);
                    } else {
                      viewModel.nextStep();
                    }
                  }
                : null,
          ),
        ],
      ),
    );
  }

  void _finishLevel(BuildContext context, int refId) {
    final level = ObjectBoxManager.levelBox.query(Level_.refId.equals(refId)).build().findFirst();

    if (level != null) {
      level.isCompleted = true;
      ObjectBoxManager.levelBox.put(level);
    }

    Navigator.pop(context);
  }
}

class _CircularNavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color backgroundColor;

  const _CircularNavigationButton({
    required this.icon,
    required this.onPressed,
    required this.backgroundColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: onPressed != null
            ? Colors.white
            : Colors.grey.shade300,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: backgroundColor,
        iconSize: 16,
      ),
    );
  }
}