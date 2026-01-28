class SQLQuestionExecutor {
  final String type;
  final String query;

  SQLQuestionExecutor({
    required this.type,
    required this.query,
  });

  ValidationResult validate() {
    // Remove espaços extras
    final cleanQuery = query.trim();

    if (cleanQuery.isEmpty) {
      return ValidationResult(
        isValid: false,
        error: "Query cannot be empty",
      );
    }

    // Valida se o tipo corresponde ao início da query
    final queryType = _extractQueryType(cleanQuery);
    
    if (queryType.toUpperCase() != type.toUpperCase()) {
      return ValidationResult(
        isValid: false,
        error: "Query type mismatch. Expected $type but got $queryType",
      );
    }

    // Validações básicas de segurança (opcional)
    if (_containsDangerousOperations(cleanQuery)) {
      return ValidationResult(
        isValid: false,
        error: "Query contains potentially dangerous operations",
      );
    }

    return ValidationResult(isValid: true);
  }

  String _extractQueryType(String query) {
    final firstWord = query.split(RegExp(r'\s+'))[0].toUpperCase();
    return firstWord;
  }

  bool _containsDangerousOperations(String query) {
    final dangerous = ['DROP DATABASE', 'TRUNCATE', 'DROP SCHEMA'];
    final upperQuery = query.toUpperCase();
    
    return dangerous.any((op) => upperQuery.contains(op));
  }

  // Factory para criar executores facilmente
  factory SQLQuestionExecutor.select(String query) {
    return SQLQuestionExecutor(type: 'SELECT', query: query);
  }

  factory SQLQuestionExecutor.insert(String query) {
    return SQLQuestionExecutor(type: 'INSERT', query: query);
  }

  factory SQLQuestionExecutor.update(String query) {
    return SQLQuestionExecutor(type: 'UPDATE', query: query);
  }

  factory SQLQuestionExecutor.delete(String query) {
    return SQLQuestionExecutor(type: 'DELETE', query: query);
  }
}

class ValidationResult {
  final bool isValid;
  final String? error;

  ValidationResult({
    required this.isValid,
    this.error,
  });
}