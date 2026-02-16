import 'package:flutter/material.dart';
import 'package:sql_plataform/core/database/objectbox.g.dart';
import 'package:sql_plataform/core/database/objectbox_manager.dart';
import 'package:sql_plataform/core/theme/app_colors.dart';

class EssayQuestionContainer extends StatefulWidget {
  final int refId;

  const EssayQuestionContainer({Key? key, required this.refId}) : super(key: key);

  @override
  State<EssayQuestionContainer> createState() => _EssayQuestionContainerState();
}

class _EssayQuestionContainerState extends State<EssayQuestionContainer> {
  bool isInverted = false;

  void toggleLayout() {
    setState(() {
      isInverted = !isInverted;
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = ObjectBoxManager.questionBox
        .query(Question_.refId.equals(widget.refId))
        .build()
        .findFirst();

    if (question == null) {
      throw ArgumentError("Invalid refId Question: ${widget.refId}");
    }

    final type = question.type.target!.name;

    if (type != "essayQuestion") {
      throw ArgumentError("Invalid $type. Needs to be = 'essayQuestion'");
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.mediumBrown,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Column(
          children: [
            // Header com descrição da questão
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                question.description,
                style: const TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),

            // Container principal com os dois painéis em coluna
            Expanded(
              child: Column(
                children: [
                  // Painel Superior (Solução)
                  Flexible(
                    flex: isInverted ? 4 : 6, // 40% ou 60%
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

                  // Painel Inferior (Resultado)
                  Flexible(
                    flex: isInverted ? 6 : 4, // 60% ou 40%
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: _buildResultArea(
                        "Sucesso:\nexample text\n<stdio.io>\ntabela penis retornou\nasdgfd\nxcvxcvxcbxcb\n  xcbxcbxcb\n  xcbxcbxcbbdfb\nreturn 1",
                      ),
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
            color: Colors.blueGrey[700],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Solução:",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.play_circle_filled),
                  color: Colors.white,
                  iconSize: 28,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    // Ação de executar
                  },
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  text: "Teste",
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget reutilizável para área de resultado
  Widget _buildResultArea(String content) {
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
                    fontSize: 13,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey[700]),
                  onPressed: toggleLayout,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}