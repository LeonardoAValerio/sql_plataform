import 'package:objectbox/objectbox.dart';
import 'package:sql_plataform/data/models/type_question.dart';

@Entity()
class Question {
  int id = 0;
  String description;
  String dataQuestion; // Armazena como String JSON

  final type = ToOne<TypeQuestion>();

  Question({required this.description, required this.dataQuestion});
}