import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sql_plataform/core/database/objectbox.g.dart';
import 'package:sql_plataform/core/database/objectbox_manager.dart';
import 'package:sql_plataform/core/utils/path.dart';
import 'package:sql_plataform/viewmodels/level_viewmodel.dart';
import 'package:sql_plataform/views/widgets/common/app_dialog.dart';

class DialogQuestionContainer extends StatelessWidget {
  int refId;

  DialogQuestionContainer({ required this.refId, Key? key }): super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final dialog = ObjectBoxManager.dialogBox.query(Dialog_.refId.equals(refId)).build().findFirst();

    if(dialog == null) {
      throw ArgumentError("Invalid refId Dialog: $refId");
    }

    final character = dialog.character.target;

    if(character == null) {
      throw ArgumentError("Not found Character in Level");
    }

    return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: AppDialog(
                texts: dialog.texts,
              ),
            ),
            SizedBox(
              child: Image(
                image: AssetImage(pathImg(character.speakingImg)),
                fit: BoxFit.contain,
              ),
            ),
            Padding(padding: EdgeInsetsGeometry.all(16.0))
          ],
        )
    );
  }
}