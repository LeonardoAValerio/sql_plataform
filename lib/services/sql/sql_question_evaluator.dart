import 'dart:convert';

import 'package:sql_plataform/services/sql/sql_evaluation_result.dart';
import 'package:sql_plataform/services/sql/sql_execution_result.dart';
import 'package:sql_plataform/services/sql/sql_question_executor.dart';
import 'package:sql_plataform/services/sql/sql_question_manager.dart';

class SQLQuestionEvaluator {
  final SQLQuestionManager manager;
  final Map<String, dynamic> questionData; // O JSON da questão

  SQLQuestionEvaluator({
    required this.manager,
    required this.questionData,
  });

  Future<EvaluationResult> evaluate(String userQuery) async {
    final resultConfig = questionData['result'];
    final expectedType = resultConfig['type'];
    
    final userResult = await manager.executeQuery(
      SQLQuestionExecutor(type: expectedType, query: userQuery)
    );
    
    if (!userResult.success) {
      return EvaluationResult.errorManager(
        userResult.error!,
      );
    }

    // 3. Dependendo do tipo, processa diferente
    switch (expectedType) {
      case 'SELECT':
        final expectResult = resultConfig['result'].cast<Map<String, dynamic>>();
        return _evaluateSelect(userResult, expectResult);
        
      case 'INSERT':
      case 'UPDATE':
      case 'DELETE':
        return await _evaluateModification(resultConfig);
        
      default:
        return EvaluationResult.errorManager('Tipo não suportado: $expectedType');
    }
  }

  EvaluationResult _evaluateSelect(SqlExecutionResult userResult, List<Map<String, dynamic>> expectResult) {    
    if(userResult.rowCount != expectResult.length) {
      return EvaluationResult.errorEvaluation('O tamanho dos resultados não batem', userResult.rows!);
    }

    final result = userResult.rows;

    if (result == null) {
      return EvaluationResult.errorEvaluation('Não foi encontrado nenhum resultado da Query', result!);
    }

    for (var i = 0; i < expectResult.length; i++) {
      final exceptElement = expectResult[i];
      final resultElement = result[i];

      final exceptElementString = jsonEncode(exceptElement);
      final resultElementString = jsonEncode(resultElement);

      if (exceptElementString != resultElementString) {
        return EvaluationResult.errorEvaluation(
          "Na linha $i o resultado recebido não foi como esperado.\n"
          "Recebido: $resultElementString\n"
          "Esperado: $exceptElementString",
          result,
        );
      }
    }

    return EvaluationResult(
      isCorrect: true,
      userResult: result,
    );
  }

  Future<EvaluationResult> _evaluateModification(Map<String, dynamic> config) async {
    final executor = SQLQuestionExecutor.select(config['query']);
    final result = await manager.executeQuery(executor);

    if (!result.success) {
      return EvaluationResult.errorManager('Algo deu errado!');
    }

    final expectResult = config['result'].cast<Map<String, dynamic>>();
    return _evaluateSelect(result, expectResult);
  }
}