import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sql_plataform/core/database/objectbox.g.dart';
import 'package:sql_plataform/core/database/objectbox_manager.dart';
import 'package:sql_plataform/core/utils/path.dart';
import 'package:sql_plataform/models/level.dart';
import 'package:sql_plataform/viewmodels/level_viewmodel.dart';
import 'package:sql_plataform/views/widgets/level/level_footer.dart';
import 'package:sql_plataform/views/widgets/level/step_indicator.dart';

class LevelScreen extends StatelessWidget {
  final int refId;

  LevelScreen({required this.refId});

  @override
  Widget build(BuildContext context) {
    final level = ObjectBoxManager.levelBox.query(Level_.refId.equals(refId)).build().findFirst();

    if(level == null) {
      throw ArgumentError("Invalid refId Level: $refId");
    }

    final chapter = level.chapter.target;

    if(chapter == null) {
      throw ArgumentError("Not found Chapter in Level");
    }

    return ChangeNotifierProvider(
      create: (_) => LevelViewModel(level)..initialize(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(level.name),
          backgroundColor: Color(chapter.color),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(pathImg(chapter.backgroundImgPath)),
              fit: BoxFit.cover
            )
          ),
          child: Center(
            child:  Column(
              children: [
                Expanded(
                  child: Consumer<LevelViewModel>(
                  builder: (context, viewModel, _) {
                    return _buildContentByType(
                      viewModel.currentStep,
                      viewModel,
                      );
                    },
                  ),
                ),
                LevelFooter()
              ],
            ),
          )
        ),
      ), 
    );
  }

   Widget _buildContentByType(LevelStep step, LevelViewModel viewModel) {
    switch (step.type) {
      case "dialog":
        return Text("${step.type} - ${step.refId}");
        
      case "objective":
        return Text("${step.type} - ${step.refId}");
        
      case "essay":
        return Text("${step.type} - ${step.refId}");

      default:
        return Text("Algo deu errado! Não existe este tipo de interface!");
    }
  }
}