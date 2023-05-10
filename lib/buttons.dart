import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:character_chainer/model/model.dart';
import 'package:character_chainer/ui/app_info_view.dart';
import 'package:character_chainer/ui/info_view_handler.dart';
import 'package:ruby_text/ruby_text.dart';

class MLRecognizedCharacterButton extends StatelessWidget {
  final String character;
  final bool error; // TODO ?: error colouring -- when validateKanji() returns a failure.
  final VoidCallback onSubmit;

  const MLRecognizedCharacterButton({
    super.key,
    required this.character,
    this.error = false,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      // color: error ? const Color.fromARGB(255, 198, 55, 45) : Colors.grey[200],
      color: Colors.grey[200],
      margin: const EdgeInsets.all(1.0),
      child: TextButton(
        onPressed: onSubmit,
        child: Text(
          character,
          style:
              // error ? const TextStyle(fontSize: 25, color: Colors.black) : const TextStyle(fontSize: 25, color: Color.fromARGB(255, 233, 233, 233)),
              const TextStyle(fontSize: 25, color: Colors.black),
        ),
      ),
    );
  }
}

class PunctuationButton extends StatelessWidget {
  final String sign;
  final VoidCallback onSubmit;

  const PunctuationButton({
    super.key,
    required this.sign,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 5.1), // padding: pushes this.sign to centre
      color: Colors.grey[300],
      child: TextButton(
        onPressed: onSubmit,
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

class UsersCharacterListButton extends StatelessWidget {
  final LanguageConfig config;
  final String character;

  const UsersCharacterListButton({
    super.key,
    required this.character,
    required this.config,
  });

  bool get isPunctuation => character == '。' || character == '、' || !config.dictionary.containsKey(character);

  void getScreen(BuildContext context, String character, bool isPunctuation) {
    if (!isPunctuation) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => InfoView(
                    character: character,
                    config: config,
                  )));
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
          character,
          style: const TextStyle(fontSize: 25, color: Colors.black),
        ),
        onPressed: () {
          getScreen(context, character, isPunctuation);
        },
      ),
    );
  }
}

class BlackComparisonCharacterButton extends StatelessWidget {
  final LanguageConfig config;

  const BlackComparisonCharacterButton({
    super.key,
    required this.character,
    required this.config,
  });

  final String character;

  bool get isPunctuation => character == '。' || character == '、' || (config.dictionary.containsKey(character) ? false : true);

  void getScreen(BuildContext context, String kanji, bool isPunctuation) {
    if (isPunctuation == false) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => InfoView(character: kanji, config: config)));
    } else {
      // TODO ?: this.buttoncolour etc etc
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      color: Colors.grey[900],
      child: TextButton(
        child: Text(
          character,
          style: TextStyle(fontSize: 50, color: Colors.grey[200], height: 1.225),
        ),
        onPressed: () {
          getScreen(context, character, isPunctuation);
        },
      ),
    );
  }
}

// InfoRow is used in Infoviews.
class InfoRow extends StatelessWidget {
  const InfoRow({Key? key, required this.leftText, required this.rightText}) : super(key: key);

  final String leftText;
  final String rightText;
  int get length => rightText.length;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: IntrinsicHeight(
        child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // LEFT: the category definition e.g. "english translation" or "pronunciation"
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

// This "rubyrow" is a special-case implementation for when furigana superscript is needed above a Japanese word.
class RubyRow extends StatelessWidget {
  const RubyRow({Key? key, required this.leftText, required this.rightText, required this.ruby}) : super(key: key);

  final String leftText;
  final List<String> rightText;
  final List<String> ruby;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
