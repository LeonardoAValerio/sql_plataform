import 'package:flutter/material.dart';
import 'package:sql_plataform/core/database/objectbox.g.dart';
import 'package:sql_plataform/core/database/objectbox_manager.dart';
import 'package:sql_plataform/core/utils/path.dart';
import 'package:sql_plataform/models/level.dart';
import 'package:sql_plataform/views/widgets/chapter/level_card.dart';

class ChapterScreen extends StatelessWidget {
  final int chapterId; 
  
  ChapterScreen(this.chapterId);

  @override
  Widget build(BuildContext context) {
    final chapter = ObjectBoxManager.chapterBox.query(Chapter_.refId.equals(chapterId)).build().findFirst();
    if(chapter == null) {
      throw ArgumentError("Not found ChapterId");
    }

    final character = chapter.character.target;
    if(character == null) {
      throw ArgumentError("Not found Character in Chapter");
    }

    final levels = ObjectBoxManager.levelBox.query(Level_.chapter.equals(chapter.id)).build().find();
    levels.sort((a, b) => a.refId.compareTo(b.refId));

    if(levels.isEmpty) {
      throw ArgumentError("Chapter Not found Levels");
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.white, // ou a cor que você quiser para a seta
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(pathImg(chapter.backgroundImgPath)),
            fit: BoxFit.cover
          )
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 32),
              Image(image: AssetImage(pathImg(character.defaultImg!))),
              SizedBox(height: 32),
              SizedBox(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 16.0,
                  children: <Widget>[
                    ..._buildLevelCards(levels)
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<LevelCard> _buildLevelCards(List<Level> levels) {    
    final lastCompleted = levels.lastIndexWhere((element) => element.isCompleted);
    final index = lastCompleted != -1 ? lastCompleted + 1 : 0;
    final lastOpened = levels[index];

    return levels.map(
      (e) => LevelCard(
        level: e.name, 
        refIdLevel: e.refId, 
        isCompleted: e.isCompleted, 
        isAble: e.isCompleted || e == lastOpened))
      .toList();
  }
}