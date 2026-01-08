import 'dart:typed_data';
import 'package:objectbox/objectbox.dart';
import 'package:sql_plataform/data/models/chapter.dart';

@Entity()
class Faq {
  int id = 0;
  String question;
  String answer;
  Uint8List idEmbedded; // Equivalente ao BLOB

  final chapter = ToOne<Chapter>();

  Faq({
    required this.question,
    required this.answer,
    required this.idEmbedded,
  });
}