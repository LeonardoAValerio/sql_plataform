class SQLManagerException implements Exception {
  final String message;

  SQLManagerException({required this.message});

  @override
  String toString() {
    return message;
  }
}

class QuestionValidateException implements Exception {
  final String message;
  final List<Map<String, dynamic>> exceptResult;

  QuestionValidateException({required this.message, required this.exceptResult});

  @override
  String toString() {
    return message;
  }
}