import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rensou_flutter/cubit/recognition_manager_cubit.dart';
import 'package:rensou_flutter/locator.dart';
import 'package:rensou_flutter/ui/app_info_view.dart';
import 'package:rensou_flutter/ui/jp_info_view.dart';
import 'package:ruby_text/ruby_text.dart';

class RecognizedKanjiButton extends StatelessWidget {
  const RecognizedKanjiButton({Key? key, required this.kanji, this.error = false}) : super(key: key);

  final String kanji;
  final bool error; // TODO: error colouring -- when validateKanji() returns a failure.

  void _onSubmit(context, kanji) {
    BlocProvider.of<RecognitionManagerCubit>(context).validateKanji(kanji);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      // color: error ? const Color.fromARGB(255, 198, 55, 45) : Colors.grey[200],
      color: Colors.grey[200],
      margin: const EdgeInsets.all(1.0),
      child: TextButton(
        onPressed: () {
          _onSubmit(context, kanji);
        },
        child: Text(
          kanji,
          style:
              // error ? const TextStyle(fontSize: 25, color: Colors.black) : const TextStyle(fontSize: 25, color: Color.fromARGB(255, 233, 233, 233)),
              const TextStyle(fontSize: 25, color: Colors.black),
        ),
      ),
    );
  }
}

class ListKanjiButton extends StatelessWidget {
  const ListKanjiButton({Key? key, required this.kanji}) : super(key: key);

  final String kanji;

  bool get isPunctuation => kanji == '。' || kanji == '、' || !locator<Dictionary>().containsKey(kanji) ? true : false;

  getScreen(context, kanji, isPunctuation) {
    if (isPunctuation == false) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => KanjiInfoView(kanji: kanji)));
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
          style: const TextStyle(fontSize: 25, color: Colors.black),
        ),
        onPressed: () {
          getScreen(context, kanji, isPunctuation);
        },
      ),
    );
  }
}

class ComparisonKanjiButton extends StatelessWidget {
  const ComparisonKanjiButton({Key? key, required this.kanji}) : super(key: key);

  final String kanji;

  bool get isPunctuation => kanji == '。' || kanji == '、' || !locator<Dictionary>().containsKey(kanji) ? true : false;

  getScreen(context, kanji, isPunctuation) {
    if (isPunctuation == false) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => KanjiInfoView(kanji: kanji)));
    } else {
      // TODO: this.buttoncolour etc etc
      return;
    }
  }

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
        onPressed: () {
          getScreen(context, kanji, isPunctuation);
        },
      ),
    );
  }
}

class PunctuationButton extends StatelessWidget {
  const PunctuationButton({Key? key, required this.sign}) : super(key: key);

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

class InfoRow extends StatelessWidget {
  const InfoRow({Key? key, required this.leftText, required this.rightText}) : super(key: key);

  final String leftText;
  final String rightText;
  int get length => rightText.length;

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
              SizedBox(
                width: 100,
                child: DottedBorder(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  color: const Color.fromARGB(255, 64, 64, 64),
                  strokeWidth: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
                    child: Text(
                      leftText,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              // RIGHT: info thereabout

              Expanded(
                child: DottedBorder(
                  padding: const EdgeInsets.fromLTRB(10, 14, 10, 10),
                  color: const Color.fromARGB(255, 64, 64, 64),
                  strokeWidth: 1,
                  child: Center(
                    child: Text(
                      rightText,
                      style: length > 25
                          ? const TextStyle(
                              fontSize: 17,
                            )
                          : const TextStyle(
                              fontSize: 20,
                            ),
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}

class RubyRow extends StatelessWidget {
  const RubyRow({Key? key, required this.leftText, required this.rightText, required this.ruby}) : super(key: key);

  final String leftText;
  final List<String> rightText;
  final List<String> ruby;

  // String get finalText =>
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
              SizedBox(
                width: 100,
                child: DottedBorder(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  color: const Color.fromARGB(255, 64, 64, 64),
                  strokeWidth: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
                    child: Text(
                      leftText,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              // RIGHT: info thereabout
              Expanded(
                child: DottedBorder(
                  padding: const EdgeInsets.all(10.0),
                  color: const Color.fromARGB(255, 64, 64, 64),
                  strokeWidth: 1,
                  child: Center(
                    child: RubyText(
                      rubyStyle: const TextStyle(fontSize: 9, letterSpacing: 0.1),
                      style: const TextStyle(
                        fontSize: 20,
                        letterSpacing: 1.0,
                      ),
                      [for (var i = 0; i < rightText.length; i++) (RubyTextData(" ${rightText[i]}, ", ruby: "${ruby[i]} "))],
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}

class InfoButton extends StatelessWidget {
  const InfoButton({Key? key, required this.text}) : super(key: key);

  final String text;

  getScreen(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const AppInfoView()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      color: const Color.fromARGB(255, 49, 49, 49),
      child: TextButton(
        onPressed: () {
          getScreen(context);
        },
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 25,
            color: Color.fromARGB(255, 214, 214, 214),
            height: 1.26,
          ),
        ),
      ),
    );
  }
}
