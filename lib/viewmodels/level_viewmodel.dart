import 'package:flutter/material.dart';
import 'package:sql_plataform/models/level.dart';

class LevelViewModel extends ChangeNotifier {
  final Level level;
  
  LevelViewModel(this.level);

  late List<LevelStep> _steps;
  int _currentStepIndex = 0;

  List<LevelStep> get steps => _steps;
  int get currentStepIndex => _currentStepIndex;
  LevelStep get currentStep => _steps[_currentStepIndex];
  
  int get totalSteps => _steps.length;
  double get progress => (_currentStepIndex + 1) / totalSteps;
  
  bool get isFirstStep => _currentStepIndex == 0;
  bool get isLastStep => _currentStepIndex == totalSteps - 1;

  void initialize() {
    _steps = level.levelSteps;
    notifyListeners();
  }

  void nextStep() {
    if (!isLastStep) {
      _currentStepIndex++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (!isFirstStep) {
      _currentStepIndex--;
      notifyListeners();
    }
  }

  void goToStep(int index) {
    if (index >= 0 && index < totalSteps) {
      _currentStepIndex = index;
      notifyListeners();
    }
  }

  bool canProceed() {
    switch (currentStep.type) {
      case "dialog":
        return true; // Sempre pode prosseguir
      case "objective":
        return true; // Implementar lógica
      case "essay":
        return true;
      default:
        throw ArgumentError("Invalid type step: ${currentStep.type}");
    }
  }
}