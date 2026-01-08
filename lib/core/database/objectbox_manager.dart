import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sql_plataform/data/models/config.dart';
import 'objectbox.g.dart'; 

class ObjectBoxManager {
  late final Store store;

  static late final Box<Config> configBox;

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
  }
}