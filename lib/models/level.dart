import 'dart:convert';

import 'package:objectbox/objectbox.dart';
import 'package:sql_plataform/models/chapter.dart';

@Entity()
class Level {
  int id = 0;
  
  @Unique()
  int refId;
  String name;
  int position;
  String dataLevel; // Armazena como String JSON
  bool isCompleted = false;

  final chapter = ToOne<Chapter>();

  Level({
    required this.refId,
    required this.name,
    required this.position,
    required this.dataLevel,
    this.isCompleted = false,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      refId: json["refId"],
      name: json["name"],
      position: json["position"],
      dataLevel: jsonEncode(json["dataLevel"]),
    );
  }

  List<LevelStep> get levelSteps {
    final parsedData = jsonDecode(dataLevel) as List<dynamic>;

    return parsedData
        .map((e) => LevelStep.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  String toString() {
    return "Level{refId: $refId, name: $name, position: $position, dataLevel: $dataLevel, isCompleted: $isCompleted}";
  }
}

class LevelStep {
  int refId;
  String type;

  LevelStep({required this.refId, required this.type});

  factory LevelStep.fromJson(Map<String, dynamic> json) {
    return LevelStep(
      refId: json['refId'],
      type: json['type'],
    );
  }
}