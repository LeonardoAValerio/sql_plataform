import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AppMarkdown extends StatelessWidget {
  final String data;
  final MarkdownStyleSheet? styleSheet;
  final bool selectable;
  
  const AppMarkdown({
    Key? key,
    required this.data,
    this.styleSheet,
    this.selectable = false,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final defaultStyleSheet = MarkdownStyleSheet.fromTheme(
      Theme.of(context),
    ).copyWith(
      p: TextStyle(fontSize: 16, height: 1.5),
      strong: TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
      em: TextStyle(
        fontStyle: FontStyle.italic,
        color: Colors.green.shade700,
      ),
      code: TextStyle(
        backgroundColor: Colors.grey.shade200,
        fontFamily: 'monospace',
        fontSize: 14,
        color: Colors.red.shade700,
      ),
      codeblockDecoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    return MarkdownBody(
      data: data,
      styleSheet: styleSheet ?? defaultStyleSheet,
      selectable: selectable,
    );
  }
}