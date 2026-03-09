import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sql_plataform/core/database/objectbox.g.dart';
import 'package:sql_plataform/core/database/objectbox_manager.dart';
import 'package:sql_plataform/core/theme/app_colors.dart';
import 'package:sql_plataform/models/question.dart';
import 'package:sql_plataform/viewmodels/level_viewmodel.dart';
import 'package:sql_plataform/views/widgets/common/app_markdown.dart';

class ObjectiveQuestionContainer extends StatefulWidget {
  final int refId;

  const ObjectiveQuestionContainer({Key? key, required this.refId})
    : super(key: key);

  @override
  State<ObjectiveQuestionContainer> createState() =>
      _ObjectiveQuestionContainerState();
}

class _ObjectiveQuestionContainerState
    extends State<ObjectiveQuestionContainer> {
  late Question _question;
  late List<dynamic> _options;
  late int _correctOptionId;

  int? _selectedIndex;
  bool _answered = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();

    final question = ObjectBoxManager.questionBox
        .query(Question_.refId.equals(widget.refId))
        .build()
        .findFirst();

    if (question == null) {
      throw ArgumentError("Question not found for refId ${widget.refId}");
    }

    _question = question;

    final data = jsonDecode(_question.dataQuestion);
    _options = data["options"];
    _correctOptionId = data["correctOption"];
  }

  void _selectOption(int index) {
    if (_answered) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  void _resetQuestion() {
    setState(() {
      _selectedIndex = null;
      _answered = false;
      _isCorrect = false;
    });
  }

  void _checkAnswer() {
    if (_selectedIndex == null) return;

    final selectedOption = _options[_selectedIndex!];
    final selectedId = selectedOption["id"];

    final isCorrect = selectedId == _correctOptionId;

    setState(() {
      _answered = true;
      _isCorrect = isCorrect;
    });

    final viewModel = Provider.of<LevelViewModel>(context, listen: false);

    viewModel.markStepAsCompleted(widget.refId, isCorrect);
  }

  Color _getOptionColor(int index) {
    final optionId = _options[index]["id"];

    if (!_answered) {
      if (_selectedIndex == index) {
        return Colors.brown.shade200;
      }
      return Colors.orange.shade200;
    }

    if (optionId == _correctOptionId) {
      return Colors.green.shade300;
    }

    if (_selectedIndex == index && !_isCorrect) {
      return Colors.red.shade300;
    }

    return Colors.orange.shade200;
  }

  Widget _buildOption(int index) {
    final option = _options[index];
    final optionId = option["id"];

    return GestureDetector(
      onTap: () => _selectOption(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getOptionColor(index),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color.fromARGB(50, 0, 0, 0),
            width: 3,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option["text"],
                style: const TextStyle(fontFamily: "monospace", fontSize: 16, height: 1.4,),
              ),
            ),

            if (_answered && optionId == _correctOptionId)
              const Icon(Icons.check, color: Colors.green, size: 26),

            if (_answered && _selectedIndex == index && !_isCorrect)
              const Icon(Icons.close, color: Colors.red, size: 26),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightBrown,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // desc
            Padding(
              padding: const EdgeInsets.all(20),
              child: AppMarkdown(data: _question.description),
            ),

            // alternativas
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _options.length,
                itemBuilder: (context, index) {
                  return _buildOption(index);
                },
              ),
            ),

            // botao
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  if (!_answered) {
                    _checkAnswer();
                  } else if (!_isCorrect) {
                    _resetQuestion();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  backgroundColor: _answered
                      ? (_isCorrect
                            ? Colors.green.shade300
                            : Colors.orange.shade300)
                      : Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  !_answered
                      ? "RESPONDER"
                      : _isCorrect
                      ? "ACERTOU! SIGA PARA A PRÓXIMA"
                      : "TENTE NOVAMENTE",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
