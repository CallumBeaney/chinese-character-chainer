import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rensou_flutter/cubit/recognition_manager_cubit.dart';

class RecognizedKanjiButton extends StatelessWidget {
  const RecognizedKanjiButton({Key? key, required this.kanji, this.error = false}) : super(key: key);

  final String kanji;
  // final String comparatorKanji;
  final bool error;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      color: Colors.grey[200],
      margin: const EdgeInsets.all(1.0),
      child: TextButton(
        onPressed: () => {BlocProvider.of<RecognitionManagerCubit>(context).validateKanji(kanji)},
        child: Text(
          kanji,
          style: const TextStyle(fontSize: 24, color: Colors.black),
        ),
        // onPressed: () {}, // () => context.read<KanjiCubit>().validateKanji(),
      ),
    );

    // void _onSubmit() {
    //   setState(() {
    //     _points.clear();
    //   });
    //   BlocProvider.of<RecognitionManagerCubit>(context).validateKanji(newKanji, previousKanji);
    // }
  }
}

class ListKanjiButton extends StatelessWidget {
  const ListKanjiButton({Key? key, required this.kanji}) : super(key: key);

  final String kanji;

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

class ComparisonKanjiButton extends StatelessWidget {
  const ComparisonKanjiButton({Key? key, required this.kanji}) : super(key: key);

  final String kanji;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      color: Colors.grey[900],
      // margin: const EdgeInsets.all(1.0),
      child: TextButton(
        child: Text(
          kanji,
          style: TextStyle(fontSize: 50, color: Colors.grey[200], height: 1.225),
        ),
        onPressed: () {}, // () => context.read<KanjiCubit>().validateKanji(),
      ),
    );
  }
}
