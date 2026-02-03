import 'package:flutter/material.dart';
import 'package:sql_plataform/core/services/dialog_service.dart';

class FirstDialogScreen extends StatelessWidget {
  const FirstDialogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Buscar o diálogo com ID 1 (primeira conversa) com o username já substituído
    final dialogFullText = DialogService.getDialogFullText(1);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                dialogFullText ?? 'Diálogo não encontrado',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}