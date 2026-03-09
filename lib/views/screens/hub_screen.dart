import 'package:flutter/material.dart';
import 'package:sql_plataform/core/database/objectbox.g.dart';
import 'package:sql_plataform/core/database/objectbox_manager.dart';
import 'package:sql_plataform/models/chapter.dart';
import 'package:sql_plataform/models/level.dart';
import 'package:sql_plataform/views/screens/chapter_screen.dart';

class HubScreen extends StatefulWidget {
  const HubScreen({super.key});

  @override
  State<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends State<HubScreen> {

  bool chapter1Completed = false;
  bool chapter2Completed = false;
  bool chapter3Completed = false;

  @override
  void initState() {
    super.initState();
    _checkChapterCompletion(1);
    _checkChapterCompletion(2);
    _checkChapterCompletion(3);
  }

  void _checkChapterCompletion(int chapterRefId) {
    final chapter = ObjectBoxManager.chapterBox
        .query(Chapter_.refId.equals(chapterRefId))
        .build()
        .findFirst();

    if (chapter == null) return;

    final levels = ObjectBoxManager.levelBox
        .query(Level_.chapter.equals(chapter.id))
        .build()
        .find();

    if (levels.isEmpty) return;

    final allCompleted = levels.every((level) => level.isCompleted);

    setState(() {
      if (chapterRefId == 1) chapter1Completed = allCompleted;
      if (chapterRefId == 2) chapter2Completed = allCompleted;
      if (chapterRefId == 3) chapter3Completed = allCompleted;
    });
  }

  void _refreshChapters() {
    _checkChapterCompletion(1);
    _checkChapterCompletion(2);
    _checkChapterCompletion(3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 80),
        _buildHacker(),
        const SizedBox(height: 60),
        _buildButtons(context),
      ],
    );
  }

  Widget _buildHacker() {
    return GestureDetector(
      onTap: () {
        debugPrint('faq');
      },
      child: Image.asset(
        'assets/images/hacker.png',
        width: 180,
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            _buildStageButton(
              image: 'assets/images/crown_cr.png',
              enabled: true,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChapterScreen(1),
                  ),
                );

                _refreshChapters();
              },
            ),

            const SizedBox(width: 20),

            _buildStageButton(
              image: chapter1Completed
                  ? 'assets/images/pokeball.png'
                  : 'assets/images/unknown_phase.png',
              enabled: chapter1Completed,
              onTap: chapter1Completed
                  ? () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChapterScreen(2),
                        ),
                      );

                      _refreshChapters();
                    }
                  : null,
            ),
          ],
        ),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStageButton(
              image: chapter2Completed
                  ? 'assets/images/mine_icon.png'
                  : 'assets/images/unknown_phase.png',
              enabled: chapter2Completed,
              onTap: chapter2Completed
                  ? () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChapterScreen(3),
                        ),
                      );

                      _refreshChapters();
                    }
                  : null,
            ),

            const SizedBox(width: 20),

            _buildStageButton(
              image: chapter3Completed
                  ? 'assets/images/lol_icon.png'
                  : 'assets/images/unknown_phase.png',
              enabled: chapter3Completed,
              onTap: chapter3Completed
                  ? () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChapterScreen(4),
                        ),
                      );

                      _refreshChapters();
                    }
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStageButton({
    required String image,
    required bool enabled,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.4,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Image.asset(
              image,
              width: 60,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}