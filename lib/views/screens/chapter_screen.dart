import 'package:flutter/material.dart';
import 'package:sql_plataform/core/database/objectbox.g.dart';
import 'package:sql_plataform/core/database/objectbox_manager.dart';
import 'package:sql_plataform/core/utils/path.dart';
import 'package:sql_plataform/models/chapter.dart';
import 'package:sql_plataform/models/level.dart';
import 'package:sql_plataform/views/widgets/chapter/level_card.dart';

class ChapterScreen extends StatefulWidget {
  final int chapterId;

  ChapterScreen(this.chapterId);

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  late Chapter chapter;
  late List<Level> levels;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final loadedChapter = ObjectBoxManager.chapterBox
        .query(Chapter_.refId.equals(widget.chapterId))
        .build()
        .findFirst();

    if (loadedChapter == null) {
      throw ArgumentError("Not found ChapterId");
    }

    if (loadedChapter.character.target == null) {
      throw ArgumentError("Not found Character in Chapter");
    }

    final loadedLevels = ObjectBoxManager.levelBox
        .query(Level_.chapter.equals(loadedChapter.id))
        .build()
        .find();
    
    loadedLevels.sort((a, b) => a.refId.compareTo(b.refId));

    if (loadedLevels.isEmpty) {
      throw ArgumentError("Chapter Not found Levels");
    }

    setState(() {
      chapter = loadedChapter;
      levels = loadedLevels;
    });
  }

  @override
  Widget build(BuildContext context) {
    final character = chapter.character.target!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(pathImg(chapter.backgroundImgPath)),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
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
                      ..._buildLevelCards(levels),
                    ],
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<LevelCard> _buildLevelCards(List<Level> levels) {
    final lastCompletedIndex = levels.lastIndexWhere((element) => element.isCompleted);
    final nextLevelIndex = lastCompletedIndex + 1;

    return levels.asMap().entries.map((entry) {
      final index = entry.key;
      final level = entry.value;

      final isAble = level.isCompleted || 
                    (index == nextLevelIndex && index < levels.length);

      return LevelCard(
        level: level.name,
        refIdLevel: level.refId,
        isCompleted: level.isCompleted,
        isAble: isAble,
        onLevelCompleted: _loadData,
      );
    }).toList();
  }
}