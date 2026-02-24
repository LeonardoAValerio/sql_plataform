import 'package:sql_plataform/core/database/objectbox_manager.dart';
import 'package:sql_plataform/core/database/objectbox.g.dart';
import 'package:sql_plataform/models/dialog.dart';

class DialogService {

	static Dialog? getDialogWithUsername(int dialogRefId) {
		final query = ObjectBoxManager.dialogBox
				.query(Dialog_.refId.equals(dialogRefId))
				.build();

		final dialog = query.findFirst();
		query.close();

		if (dialog == null) return null;

		final configs = ObjectBoxManager.configBox.getAll();
		final username = configs.isNotEmpty ? configs.last.username : 'maluco';

		final updatedTexts = dialog.texts
        //aq da replace do $ pelo user do cara, quiser trocar o simbolo eh so mudar aqui
				.map((text) => text.replaceAll('\$user', username))
				.toList();

		return Dialog(
			refId: dialog.refId,
			texts: updatedTexts,
		);
	}

	static List<String>? getDialogTexts(int dialogRefId){
		final dialog = getDialogWithUsername(dialogRefId);
		return dialog?.texts;
	}

	static String? getDialogFullText(int dialogRefId) {
		final texts = getDialogTexts(dialogRefId);
		return texts?.join('\n');
	}
}

