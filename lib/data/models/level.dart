import 'package:objectbox/objectbox.dart';
import 'package:sql_plataform/data/models/chapter.dart';

@Entity()
class Level {
  int id = 0;
  String name;
  int position;
  String dataLevel; // Armazena como String JSON
  bool isCompleted = false;

  final chapter = ToOne<Chapter>();

  Level({
    required this.name,
    required this.position,
    required this.dataLevel,
    this.isCompleted = false,
  });
}