import 'package:flutter/material.dart';
import './cubit/kanji_cubit.dart';

class KanjiButton extends StatelessWidget {
  const KanjiButton({Key? key, required this.kanji, this.error = false}) : super(key: key);

  final String kanji;
  final bool error;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      color: Colors.grey[200],
      margin: const EdgeInsets.all(1.0),
      child: TextButton(
        child: Text(
          kanji,
          style: const TextStyle(fontSize: 24, color: Colors.black),
        ),
        onPressed: () {}, // () => context.read<KanjiCubit>().validateKanji(),
      ),
    );
  }
}
