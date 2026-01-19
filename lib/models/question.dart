import 'dart:convert';

import 'package:objectbox/objectbox.dart';
import 'package:sql_plataform/models/type_question.dart';

@Entity()
class Question {
  int id = 0;
  @Unique()
  int refId;
  String description;
  String dataQuestion; // Armazena como String JSON

  final type = ToOne<TypeQuestion>();

  Question({required this.refId, required this.description, required this.dataQuestion});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      refId: json['refId'],
      description: json['description'],
      dataQuestion: jsonEncode(json['dataQuestion'])
      );
  }

  @override
  String toString() {
    return 'Question{refId: $refId, description: $description, dataQuestion: $dataQuestion}';
  }
}