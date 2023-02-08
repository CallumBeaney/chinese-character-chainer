import 'package:flutter/material.dart';

class KanjiButton extends StatelessWidget {
  const KanjiButton({Key? key, required this.kanji}) : super(key: key);

  final String kanji;

  @override
  Widget build(BuildContext context) {
    return TextButton(child: Text(kanji), onPressed: () {});
  }
}
