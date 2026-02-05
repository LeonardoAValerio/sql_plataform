import 'package:objectbox/objectbox.dart';

@Entity()
class TypeQuestion {
  @Id()
  int id = 0;

  @Unique()
  int refId;

  String name;

  TypeQuestion({required this.refId, required this.name});

  factory TypeQuestion.fromJson(Map<String, dynamic> json) {
    return TypeQuestion(refId: json['refId'], name: json['name']);
  }

  @override
  String toString() {
    return 'TypeQuestion{refId: $refId, name: $name}';
  }
}