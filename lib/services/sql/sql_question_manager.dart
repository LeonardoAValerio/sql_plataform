import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sql_plataform/core/database/objectbox_manager.dart';
import 'package:sql_plataform/models/question.dart';
import 'package:sql_plataform/services/sql/sql_execution_result.dart';
import 'package:sql_plataform/services/sql/sql_question_executor.dart';

class SQLQuestionManager {
  Database? _db;
  final int refIdQuestion;
  bool _isInitialized = false;

  SQLQuestionManager({required this.refIdQuestion});

  String get filename => 'question_$refIdQuestion.db';
  
  bool get isInitialized => _isInitialized;
  
  Database get db {
    if (_db == null || !_isInitialized) {
      throw StateError("Database not initialized. Call init() first.");
    }
    return _db!;
  }

  Future<void> init() async {
    if (_isInitialized) {
      print("[SQLQuestionManager] Already initialized, skipping...");
      return;
    }

    await close();
    
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filename);

    // Remove banco anterior se existir
    await deleteDatabase(path);

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _insertQuestionsData(db);
      },
    );

    _isInitialized = true;
    print("[SQLQuestionManager] Initialized database: $filename");
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
    _isInitialized = false;
    print("[SQLQuestionManager] Closed database: $filename");
  }

  Future<void> reset() async {
    print("[SQLQuestionManager] Resetting database...");
    await init(); // Recria o banco do zero
  }

  Future<SqlExecutionResult> executeQuery(SQLQuestionExecutor executor) async {
    if (!_isInitialized) {
      return SqlExecutionResult(
        success: false,
        error: "Database not initialized",
        executionTime: Duration.zero,
      );
    }

    // Valida a query primeiro
    final validation = executor.validate();
    if (!validation.isValid) {
      return SqlExecutionResult(
        success: false,
        error: "Validation error: ${validation.error}",
        executionTime: Duration.zero,
      );
    }

    final stopwatch = Stopwatch()..start();

    try {
      final result = await _executeByType(executor);
      stopwatch.stop();

      return SqlExecutionResult(
        success: true,
        rows: result['rows'],
        affectedRows: result['affectedRows'],
        executionTime: stopwatch.elapsed,
      );
    } catch (e) {
      stopwatch.stop();
      
      return SqlExecutionResult(
        success: false,
        error: e.toString(),
        executionTime: stopwatch.elapsed,
      );
    }
  }

  Future<Map<String, dynamic>> _executeByType(SQLQuestionExecutor executor) async {
    switch (executor.type.toUpperCase()) {
      case 'SELECT':
        final rows = await db.rawQuery(executor.query);
        return {
          'rows': rows,
          'affectedRows': rows.length,
        };

      case 'INSERT':
      case 'UPDATE':
      case 'DELETE':
        final affectedRows = await db.rawUpdate(executor.query);
        return {
          'rows': null,
          'affectedRows': affectedRows,
        };

      default:
        // Para DDL (CREATE, DROP, ALTER)
        await db.execute(executor.query);
        return {
          'rows': null,
          'affectedRows': 0,
        };
    }
  }

  Future<void> _insertQuestionsData(Database database) async {
    final Question? question = ObjectBoxManager.questionBox.get(refIdQuestion);

    if (question == null) {
      throw ArgumentError("Question not found with id: $refIdQuestion");
    }

    try {
      final data = jsonDecode(question.dataQuestion);
      final databaseQuery = data['databaseQuery'];
      final insertQuery = data['insertCommand'];

      if (databaseQuery == null || databaseQuery.isEmpty) {
        throw FormatException("Invalid or empty databaseQuery in question data");
      }

      print("[SQLQuestionManager] Executing initial query...");
      await database.execute(databaseQuery);
      await database.execute(insertQuery);
      print("[SQLQuestionManager] Initial data inserted successfully");
    } catch (e) {
      print("[SQLQuestionManager] Error inserting initial data: $e");
      rethrow;
    }
  }

  // Método útil para debug
  Future<List<Map<String, dynamic>>> getAllTables() async {
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"
    );
    return result;
  }

  // Método útil para ver dados de uma tabela
  Future<List<Map<String, dynamic>>> getTableData(String tableName) async {
    final result = await db.rawQuery("SELECT * FROM $tableName");
    return result;
  }
}