import 'package:flutter/material.dart';
import 'package:sql_plataform/core/services/dialog_service.dart';
import 'package:sql_plataform/views/screens/hub_screen.dart';

class FirstDialogScreen extends StatefulWidget {
  const FirstDialogScreen({super.key});

  @override
  State<FirstDialogScreen> createState() => _FirstDialogScreenState();
}

class _FirstDialogScreenState extends State<FirstDialogScreen> {
  late List<String> dialogTexts;
  int currentIndex = 0;
  bool lastDialogJustShown = false;

  @override
  void initState() {
    super.initState();
    dialogTexts = DialogService.getDialogTexts(1) ?? [];
  }

  void _nextDialog() {
  if (currentIndex < dialogTexts.length - 1) {
    setState(() {
      currentIndex++;
    });
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HubScreen(),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final currentText =
        dialogTexts.isNotEmpty ? dialogTexts[currentIndex] : '';

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildCharacter(),
          _buildDialogBox(currentText),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildCharacter() {
    return Align(
      alignment: const Alignment(0, -0.7),
      child: Image.asset(
        'assets/images/hacker.png',
        width: 200,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildDialogBox(String text) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: GestureDetector(
          onTap: _nextDialog,
          child: Stack(
            children: [
              Image.asset(
                'assets/images/hacker_textbox.png',
                width: double.infinity,
                fit: BoxFit.fill,
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
