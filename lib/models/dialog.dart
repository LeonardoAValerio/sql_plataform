import 'package:objectbox/objectbox.dart';
import 'package:sql_plataform/models/character.dart';

@Entity()
class Dialog {
  int id = 0;
  
  @Unique()
  int refId;
  List<String> texts;

  final character = ToOne<Character>();

  Dialog({required this.refId, required this.texts});

  factory Dialog.fromJson(Map<String, dynamic> json) {
    final textsFromJson = json["texts"] as List<dynamic>;
    final texts = textsFromJson.map((e) => "$e").toList();
    return Dialog(
      refId: json['refId'], 
      texts: texts
    );
  }

  @override
  String toString() {
    return "Dialog{refId: $refId, texts: $texts}";
  }
}