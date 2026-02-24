import 'package:flutter/material.dart';

class SqlHighlightController extends TextEditingController {
  // Customize as cores aqui
  static const _blue = Color(0xFF61AFEF);
  static const _green = Color(0xFF98C379);
  static const _orange = Color(0xFFE5C07B);
  static const _orangeMine = Color.fromARGB(255, 210, 161, 69);
  static const _yeloow = Color.fromARGB(255, 229, 210, 123);

  static final _firstKeywords = {
    // Azul
    'SELECT', 'FROM', 'INSERT', 'INTO', 'UPDATE', 'DELETE',
    'CREATE', 'DROP', 'ALTER', 'TABLE'
  };


  static final _secondKeywords = {
    // Verde
    'WHERE', 'AND', 'OR', 'NOT', 'IN', 'LIKE', 'BETWEEN',
    'EXISTS', 'IS', 'NULL', 'CASE', 'WHEN', 'THEN', 'ELSE', 'END',
  };
  
  static final _threeKeywords = {
    // Laranja
    'JOIN', 'LEFT', 'RIGHT', 'INNER', 'OUTER', 'ON', 'AS', 
    'DISTINCT', 'OFFSET', 'SET', 'VALUES', 'INDEX', 'VIEW',
  };

  static final _fourKeywords = {
    // Amarelo
    'BY', 'GROUP', 'HAVING', 'ORDER',  'LIMIT'
  };

  static final _wordRegex = RegExp(r"'[^']*'|\b\w+\b");

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final spans = <TextSpan>[];
    final text = this.text;

    int lastEnd = 0;

    for (final match in _wordRegex.allMatches(text)) {
      // Texto entre matches (espaços, vírgulas, etc.) sem cor especial
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, match.start),
          style: style,
        ));
      }

      final word = match.group(0)!;
      final upper = word.toUpperCase();
      Color? color;

      if (word.startsWith("'")) {
        color = _orange;
      } else if (_firstKeywords.contains(upper)) {
        color = _blue;
      } else if (_secondKeywords.contains(upper)) {
        color = _green;
      } else if (_threeKeywords.contains(upper)) {
        color = _orangeMine;
      } else if (_fourKeywords.contains(upper)) {
        color = _yeloow;
      }

      spans.add(TextSpan(
        text: word,
        style: color != null ? style?.copyWith(color: color) : style,
      ));

      lastEnd = match.end;
    }

    // Resto do texto após o último match
    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: style,
      ));
    }

    return TextSpan(children: spans, style: style);
  }
}