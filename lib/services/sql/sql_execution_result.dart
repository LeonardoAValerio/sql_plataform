class SqlExecutionResult {
  final bool success;
  final List<Map<String, dynamic>>? rows;
  final int? affectedRows;
  final String? error;
  final Duration executionTime;

  SqlExecutionResult({
    required this.success,
    this.rows,
    this.affectedRows,
    this.error,
    required this.executionTime,
  });

  bool get hasRows => rows != null && rows!.isNotEmpty;
  int get rowCount => rows?.length ?? 0;

  String get message {
    if (!success) return error ?? "Unknown error";
    if (rows != null) return "$rowCount row(s) returned";
    if (affectedRows != null) return "$affectedRows row(s) affected";
    return "Query executed successfully";
  }
}