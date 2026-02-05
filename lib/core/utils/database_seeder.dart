import 'dart:convert';
import 'dart:io';

import 'package:sql_plataform/core/database/objectbox.g.dart';
import 'package:sql_plataform/core/database/objectbox_manager.dart';
import 'package:sql_plataform/models/chapter.dart';
import 'package:sql_plataform/models/character.dart';
import 'package:sql_plataform/models/dialog.dart';
import 'package:sql_plataform/models/faq.dart';
import 'package:sql_plataform/models/level.dart';
import 'package:sql_plataform/models/question.dart';
import 'package:sql_plataform/models/type_question.dart';

class DatabaseSeeder {
    
  void Function(String) _logger(String? data) {
      return (String log) {
        final timestamp = DateTime.now().toString().substring(11, 19);
        final baseText = "[DatabaseSeeder]";
        final context = data == null ? baseText : '$baseText[$data]';
        print("[$timestamp] $context $log");
      };
  }

  Future<List<dynamic>> _readJsonFile(String path) async {
    final file = File(path);

    if (!await file.exists()) {
      throw FileSystemException("File not found: $path");
    }

    final jsonString = await file.readAsString();
    final decoded = json.decode(jsonString);

    if (decoded is! List) {
      throw FormatException("Expected JSON array in file: $path");
    }

    return decoded;
  }

  Future<void> seedAll() async {
    final logger = this._logger(null);

    logger("Started seeding...");

    try {
      await _seedTypeQuestion();
      await _seedQuestion();
      await _seedCharacter();
      await _seedDialog();
      await _seedChapter();
      await _seedLevel();
      await _seedFaq();
      logger("Finished seeding successfully!");
    } catch (e, stackTrace) {
      logger("Seeding failed: $e");
      print(stackTrace);
      rethrow;
    }
  }

  Future<void> _seedTypeQuestion() async {
    final logger = _logger("TypeQuestions");
    
    try {
      logger("Getting file...");
      final data = await _readJsonFile("seeds/type_questions.json");

      logger("Mapping JSON (${data.length} items)...");
      final typeQuestions = data
          .map((json) => TypeQuestion.fromJson(json))
          .toList();

      logger("Inserting data...");
      ObjectBoxManager.typeQuestionBox.putMany(typeQuestions);

      logger("Finished insertions (${typeQuestions.length} records)");
    } catch (e) {
      logger("Error: $e");
      rethrow;
    }
  }

  Future<void> _seedQuestion() async {
    final logger = _logger("Question");
    
    try {
      logger("Getting file...");
      final data = await _readJsonFile("seeds/questions.json");

      final typeQuestions = ObjectBoxManager.typeQuestionBox.getAll();
      
      if (typeQuestions.isEmpty) {
        throw StateError("TypeQuestions must be seeded before Questions");
      }

      final objectiveQuestion = typeQuestions.firstWhere(
        (element) => element.refId == 1,
        orElse: () => throw StateError("TypeQuestion with refId=1 not found"),
      );
      
      final essayQuestion = typeQuestions.firstWhere(
        (element) => element.refId == 2,
        orElse: () => throw StateError("TypeQuestion with refId=2 not found"),
      );

      logger("Mapping JSON (${data.length} items)...");
      final questions = data.map((json) {
        final question = Question.fromJson(json);
        
        question.type.target = json['typeQuestionId'] == 1 
            ? objectiveQuestion 
            : essayQuestion;

        return question;
      }).toList();

      logger("Inserting data...");
      ObjectBoxManager.questionBox.putMany(questions);

      logger("Finished insertions (${questions.length} records)");
    } catch (e) {
      logger("Error: $e");
      rethrow;
    }
  }

  Future<void> _seedCharacter() async {
    final logger = _logger("Character");
    
    try {
      logger("Getting file...");
      final data = await _readJsonFile("seeds/characters.json");

      logger("Mapping JSON (${data.length} items)...");
      final characters = data.map((json) => Character.fromJson(json)).toList();

      logger("Inserting data...");
      ObjectBoxManager.characterBox.putMany(characters);

      logger("Finished insertions (${characters.length} records)");
    } catch (e) {
      logger("Error: $e");
      rethrow;
    }
  }

  Future<void> _seedDialog() async {
    final logger = _logger("Dialog");
    
    try {
      logger("Getting file...");
      final data = await _readJsonFile("seeds/dialogs.json");

      logger("Mapping JSON (${data.length} items)...");
      final dialogs = data.map((json) {
        final dialog = Dialog.fromJson(json);
        final characterId = json['characterId'];

        final character = ObjectBoxManager.characterBox.query(Character_.refId.equals(characterId)).build().findFirst();

        if(character == null) throw StateError("Character with refId=$characterId not found");

        dialog.character.target = character;

        return dialog;
      }).toList();

      logger("Inserting data...");
      ObjectBoxManager.dialogBox.putMany(dialogs);

      logger("Finished insertions (${dialogs.length} records)");
    } catch (e) {
      logger("Error: $e");
      rethrow;
    }
  }

  Future<void> _seedChapter() async {
    final logger = _logger("Chapter");
    
    try {
      logger("Getting file...");
      final data = await _readJsonFile("seeds/chapters.json");

      logger("Mapping JSON (${data.length} items)...");

      final chapters = data.map((json) {
        final chapter = Chapter.fromJson(json);
        final characterId = json['characterId'];

        final character = ObjectBoxManager.characterBox.query(Character_.refId.equals(characterId)).build().findFirst();

        if(character == null) throw StateError("Character with refId=$characterId not found");

        chapter.character.target = character;

        return chapter;
      }).toList();

      logger("Inserting data...");
      ObjectBoxManager.chapterBox.putMany(chapters);

      logger("Finished insertions (${chapters.length} records)");
    } catch (e) {
      logger("Error: $e");
      rethrow;
    }
  }

  Future<void> _seedLevel() async {
    final logger = _logger("Level");
    
    try {
      logger("Getting file...");
      final data = await _readJsonFile("seeds/levels.json");

      logger("Mapping JSON (${data.length} items)...");

      final levels = data.map((json) {
        final level = Level.fromJson(json);
        final chapterId = json['chapterId'];

        final chapter = ObjectBoxManager.chapterBox.query(Chapter_.refId.equals(chapterId)).build().findFirst();

        if(chapter == null) throw StateError("Chapter with refId=$chapterId not found");

        level.chapter.target = chapter;

        return level;
      }).toList();

      logger("Inserting data...");
      ObjectBoxManager.levelBox.putMany(levels);

      logger("Finished insertions (${levels.length} records)");
    } catch (e) {
      logger("Error: $e");
      rethrow;
    }
  }

   Future<void> _seedFaq() async {
    final logger = _logger("Faq");
    
    try {
      logger("Getting file...");
      final data = await _readJsonFile("seeds/faqs.json");

      logger("Mapping JSON (${data.length} items)...");

      final faqs = data.map((json) {
        final faq = Faq.fromJson(json);
        final chapterId = json['chapterId'];

        final chapter = ObjectBoxManager.chapterBox.query(Chapter_.refId.equals(chapterId)).build().findFirst();

        if(chapter == null) throw StateError("Chapter with refId=$chapterId not found");

        faq.chapter.target = chapter;

        return faq;
      }).toList();

      logger("Inserting data...");
      ObjectBoxManager.faqBox.putMany(faqs);

      logger("Finished insertions (${faqs.length} records)");
    } catch (e) {
      logger("Error: $e");
      rethrow;
    }
  }

  Future<void> clearAll() async {
    final logger = _logger("Clear");
    
    logger("Clearing all data...");
    ObjectBoxManager.questionBox.removeAll();
    ObjectBoxManager.typeQuestionBox.removeAll();
    ObjectBoxManager.characterBox.removeAll();
    ObjectBoxManager.dialogBox.removeAll();
    ObjectBoxManager.chapterBox.removeAll();
    ObjectBoxManager.levelBox.removeAll();
    ObjectBoxManager.faqBox.removeAll();
    logger("All data cleared");
  }
}
