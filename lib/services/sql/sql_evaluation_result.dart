enum TypeErrorEvaluationResult {
  SQLManager,
  QuestionEvaluation
}

class EvaluationResult {
  final bool isCorrect;
  final String? errorMessage;
  final TypeErrorEvaluationResult? typeError;
  final List<Map<String, dynamic>>? userResult;

  EvaluationResult({required this.isCorrect, this.errorMessage, this.userResult, this.typeError});

  factory EvaluationResult.errorManager(String errorMessage) {
    return EvaluationResult(
      isCorrect: false, 
      errorMessage: errorMessage,
      typeError: TypeErrorEvaluationResult.SQLManager 
    );
  }

  factory EvaluationResult.errorEvaluation(String errorMessage, List<Map<String, dynamic>> userResult) {
    return EvaluationResult(
      isCorrect: false, 
      errorMessage: errorMessage,
      userResult: userResult,
      typeError: TypeErrorEvaluationResult.QuestionEvaluation 
    );
  }

  factory EvaluationResult.success(List<Map<String, dynamic>> userResult) {
    return EvaluationResult(
      isCorrect: true,
      userResult: userResult 
    );
  }
}