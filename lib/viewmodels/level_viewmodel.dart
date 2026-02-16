import 'package:flutter/material.dart';
import 'package:sql_plataform/models/level.dart';

class LevelViewModel extends ChangeNotifier {
  final Level level;
  
  LevelViewModel(this.level);

  late List<LevelStep> _steps;
  int _currentStepIndex = 0;
  
  // Mapa para armazenar o estado de conclusão de cada step
  final Map<int, bool> _stepCompletionStatus = {};

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

  // Método para marcar um step como completo
  void markStepAsCompleted(int stepRefId, bool isCorrect) {
    _stepCompletionStatus[stepRefId] = isCorrect;
    notifyListeners();
  }

  // Verifica se o step atual está completo
  bool isStepCompleted(int stepRefId) {
    return _stepCompletionStatus[stepRefId] ?? false;
  }

  void nextStep() {
    if (!isLastStep && canProceed()) {
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
    final currentStepRefId = currentStep.refId;
    
    switch (currentStep.type) {
      case "dialog":
        return true; // Sempre pode prosseguir
      case "objective":
        return true;
      case "essay":
        return isStepCompleted(currentStepRefId);
      default:
        throw ArgumentError("Invalid type step: ${currentStep.type}");
    }
  }
}