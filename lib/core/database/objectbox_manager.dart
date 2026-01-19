import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sql_plataform/models/chapter.dart';
import 'package:sql_plataform/models/character.dart';
import 'package:sql_plataform/models/config.dart';
import 'package:sql_plataform/models/dialog.dart';
import 'package:sql_plataform/models/faq.dart';
import 'package:sql_plataform/models/level.dart';
import 'package:sql_plataform/models/question.dart';
import 'package:sql_plataform/models/type_question.dart';
import 'objectbox.g.dart'; 

class ObjectBoxManager {
  late final Store store;

  static late final Box<Config> configBox;
  static late final Box<TypeQuestion> typeQuestionBox;
  static late final Box<Question> questionBox;
  static late final Box<Character> characterBox;
  static late final Box<Dialog> dialogBox;
  static late final Box<Chapter> chapterBox;
  static late final Box<Level> levelBox;
  static late final Box<Faq> faqBox;

  ObjectBoxManager._create(this.store) {
  // Adicione qualquer código de configuração adicional,
  //por exemplo construir consultas para carregar informações na 
  //inicialização de alguma tela.
  }

 /// Cria uma instância de ObjectBox para usar em todo o aplicativo.
  static Future<void> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(docsDir.path, "obx-example"));
    ObjectBoxManager._create(store);
    configBox = store.box<Config>();
    typeQuestionBox = store.box<TypeQuestion>();
    questionBox = store.box<Question>();
    characterBox = store.box<Character>();
    dialogBox = store.box<Dialog>();
    chapterBox = store.box<Chapter>();
    levelBox = store.box<Level>();
    faqBox = store.box<Faq>();
  }
}