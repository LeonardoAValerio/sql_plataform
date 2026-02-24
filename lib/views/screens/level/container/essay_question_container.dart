import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sql_plataform/core/database/objectbox.g.dart';
import 'package:sql_plataform/core/database/objectbox_manager.dart';
import 'package:sql_plataform/core/theme/app_colors.dart';
import 'package:sql_plataform/core/utils/json_to_md.dart';
import 'package:sql_plataform/models/question.dart';
import 'package:sql_plataform/services/sql/sql_evaluation_result.dart';
import 'package:sql_plataform/services/sql/sql_question_evaluator.dart';
import 'package:sql_plataform/services/sql/sql_question_manager.dart';
import 'package:sql_plataform/viewmodels/level_viewmodel.dart';
import 'package:sql_plataform/views/widgets/common/app_markdown.dart';
import 'package:sql_plataform/views/widgets/level/sql_highlight_controller.dart';

class EssayQuestionContainer extends StatefulWidget {
  final int refId;

  const EssayQuestionContainer({Key? key, required this.refId}) : super(key: key);

  @override
  State<EssayQuestionContainer> createState() => _EssayQuestionContainerState();
}

class _EssayQuestionContainerState extends State<EssayQuestionContainer> {
  bool _isInverted = false;
  String _result = "";
  final _responseController = SqlHighlightController();
  late SQLQuestionManager _sqlQuestionManager;
  late Question _question;

  void toggleLayout() {
    setState(() {
      _isInverted = !_isInverted;
    });
  }

  Future<void> executeSQL() async {
    final evaluator = SQLQuestionEvaluator(manager: _sqlQuestionManager, questionData: jsonDecode(_question.dataQuestion));
    final result = await evaluator.evaluate(_responseController.text);

    setState(() {
      if(result.errorMessage == null) {
        _result = "**Sucesso:**\n${JsonToMd.transform(result.userResult!)}\n\n Agora passe para a próxima etapa!";
      } else if(result.typeError == TypeErrorEvaluationResult.QuestionEvaluation) {
        _result = "**Resultado inválido:**\nSeu SQL não trouxe o resultado esperado\n\n **Erro:** ${result.errorMessage} \n\n **Resultado:** \n${JsonToMd.transform(result.userResult!)}";
      } else {
        _result = "**Erro: Seu SQL criado foi inválido e gerou o erro ->** ${result.errorMessage}";
      }
    });

    final viewModel = Provider.of<LevelViewModel>(context, listen: false);
    viewModel.markStepAsCompleted(widget.refId, result.isCorrect);
  }

  @override
  void dispose() {
    _responseController.dispose();
    _sqlQuestionManager.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _question = ObjectBoxManager.questionBox
        .query(Question_.refId.equals(widget.refId))
        .build()
        .findFirst()!;

    _initializeData();
  }

  Future<void> _initializeData() async {
    _sqlQuestionManager = SQLQuestionManager(refIdQuestion: widget.refId);
    await _sqlQuestionManager.init();
    
    setState(() {}); // Atualiza a UI quando os dados estiverem prontos
  }

  @override
  Widget build(BuildContext context) {
    
    final type = _question.type.target!.name;

    if (type != "essayQuestion") {
      throw ArgumentError("Invalid $type. Needs to be = 'essayQuestion'");
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightBrown,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: AppMarkdown(
                data: _question.description 
              )
            ),

            Expanded(
              child: Column(
                children: [
                  Flexible(
                    flex: _isInverted ? 4 : 6,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: _buildSolutionPanel(),
                    ),
                  ),

                  Flexible(
                    flex: _isInverted ? 6 : 4,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: _buildResultArea(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSolutionPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.gray,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const Text(
                  "Solução:",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.play_circle_filled),
                  color: Colors.black,
                  iconSize: 28,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    executeSQL();
                  },
                ),
              ],
            ),
          ),
        ),
        
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: TextField(
              controller: _responseController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: const TextStyle(
                fontFamily: "monospace",
                fontSize: 14,
              ),
              decoration: InputDecoration(
                fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.all(12),
                hintText: 'Digite seu código SQL aqui...',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Resultado:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                IconButton(
                  icon: Icon(_isInverted ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),
                  onPressed: toggleLayout,
                  iconSize: 28,
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: AppMarkdown(
                data: _result
              )
            ),
          ),
        ),
      ],
    );
  }
}