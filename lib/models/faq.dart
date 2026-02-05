
import 'package:objectbox/objectbox.dart';
import 'package:sql_plataform/models/chapter.dart';

@Entity()
class Faq {
  int id = 0;

  @Unique()
  int refId;
  String question;
  String answer;

  @HnswIndex(dimensions: 384)
  @Property(type: PropertyType.floatVector)
  List<double> embedding;

  final chapter = ToOne<Chapter>();

  Faq({
    required this.refId,
    required this.question,
    required this.answer,
    required this.embedding,
  });

  factory Faq.fromJson(Map<String, dynamic> json) {
    final embedding = (json["embedding"] as List)
      .cast<double>()
      .toList();

    return Faq(
      refId: json['refId'], 
      question: json['question'], 
      answer: json['answer'], 
      embedding: embedding
    );
  }

  @override
  String toString() {
    return "Faq{refId: $refId, refId: $question, refId: $answer, refId: $embedding}";
  }
}