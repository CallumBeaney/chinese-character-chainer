
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rensou_flutter/cubit/recognition_manager_cubit.dart';
import 'package:rensou_flutter/ui/kanji_info_view.dart';

class RecognizedKanjiButton extends StatelessWidget {
  const RecognizedKanjiButton({Key? key, required this.kanji, this.error = false}) : super(key: key);

  final String kanji;
  final bool error; // TODO: error colouring

  void _onSubmit(context, kanji) {
    BlocProvider.of<RecognitionManagerCubit>(context).validateKanji(kanji);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      color: Colors.grey[200],
      margin: const EdgeInsets.all(1.0),
      child: TextButton(
        onPressed: () {
          _onSubmit(context, kanji);
        },
        child: Text(
          kanji,
          style: const TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
    );
  }
}

class ListKanjiButton extends StatelessWidget {
  const ListKanjiButton({Key? key, required this.kanji}) : super(key: key);

  final String kanji;

  bool get isPunctuation => kanji == '。' || kanji == '、' ? true : false;

  getScreen(context, kanji, isPunctuation) {
    if (isPunctuation == false) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => kanjiInfoView(kanji: kanji)));
    } else {
      // Do nothing
      return;
    }
  }

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
        onPressed: () {
          getScreen(context, kanji, isPunctuation);
        }, // TODO: Dictionary view pop
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
        onPressed: () {}, // TODO: Dictionary lookup? Help button?
      ),
    );
  }
}

class punctuationButton extends StatelessWidget {
  const punctuationButton({Key? key, required this.sign}) : super(key: key);

  final String sign;

  void _onPush(context, kanji) {
    BlocProvider.of<RecognitionManagerCubit>(context).validateKanji(sign);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 5.1), // padding: pushes this.sign to centre
      color: Colors.grey[300],
      // margin: const EdgeInsets.symmetric(horizontal: 1.0),
      child: TextButton(
        onPressed: () {
          _onPush(context, sign);
        },
        child: Text(
          sign,
          style: TextStyle(
            fontSize: 42.5,
            color: Colors.grey[700],
            height: 0.333,
          ),
        ),
      ),
    );
  }
}

class infoRow extends StatelessWidget {
  const infoRow({Key? key, required this.leftText, required this.rightText}) : super(key: key);

  final String leftText;
  final String rightText;
  // String get rightText => rightReceiver.join(', ');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      // color: Colors.amber, // for debugging
      child: IntrinsicHeight(
        child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // LEFT: the category definition
              DottedBorder(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                color: const Color.fromARGB(255, 212, 212, 212),
                strokeWidth: 1,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
                  child: Text(
                    "$leftText ：",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              // RIGHT: info thereabout
              Expanded(
                child: DottedBorder(
                  padding: const EdgeInsets.all(10.0),
                  color: const Color.fromARGB(255, 212, 212, 212),
                  strokeWidth: 1,
                  child: Text(
                    rightText,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
