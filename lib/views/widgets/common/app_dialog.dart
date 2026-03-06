import 'package:flutter/material.dart';
import 'package:sql_plataform/views/widgets/common/circular_navigation_button.dart';

class AppDialog extends StatefulWidget {
  final List<String> texts; // Recebe diretamente os textos

  const AppDialog({
    Key? key, 
    required this.texts,
  }) : super(key: key);

  @override
  State<AppDialog> createState() => _AppDialogState();
}

class _AppDialogState extends State<AppDialog> {
  int _currentTextIndex = 0;

  void _nextText() {
    if (_currentTextIndex < widget.texts.length - 1) {
      setState(() {
        _currentTextIndex++;
      });
    }
  }

  void _previousText() {
    if (_currentTextIndex > 0) {
      setState(() {
        _currentTextIndex--;
      });
    }
  }

  bool get _isFirstText => _currentTextIndex == 0;
  bool get _isLastText => _currentTextIndex == widget.texts.length - 1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.texts[_currentTextIndex],
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.5,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircularNavigationButton(
                    icon: Icons.arrow_back_ios_new,
                    backgroundColor: Colors.grey.shade600,
                    onPressed: _isFirstText ? null : _previousText
                  ),
                  
                  Text('${_currentTextIndex + 1} / ${widget.texts.length}'),

                  CircularNavigationButton(
                    icon: Icons.arrow_forward_ios,
                    backgroundColor: Colors.grey.shade600,
                    onPressed: _isLastText ? null : _nextText
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}