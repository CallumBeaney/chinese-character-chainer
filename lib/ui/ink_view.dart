import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rensou_flutter/buttons.dart';
import 'package:rensou_flutter/cubit/recognition_manager_cubit.dart';
import 'package:rensou_flutter/model/model.dart';

import 'ink_input.dart';

class DigitalInkView extends StatefulWidget {
  final LanguageConfig config;

  const DigitalInkView({super.key, required this.config});

  @override
  State<DigitalInkView> createState() => _DigitalInkViewState();
}

class _DigitalInkViewState extends State<DigitalInkView> {
  late final RecognitionManagerCubit controller = RecognitionManagerCubit(config: widget.config);
  Dictionary get dictionary => widget.config.dictionary;
  Placeholders get placeholders => widget.config.placeholders;

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  // TODO: https://pub.dev/packages/number_to_words_chinese/install
  int getScore(List<String> answers) {
    // TODO: reconfigure to check for repeats
    return answers.map((e) => dictionary.containsKey(e)).where((r) => (r == true)).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('日本語'),
      //   toolbarHeight: 50,
      //   foregroundColor: Colors.grey[900],
      //   backgroundColor: Colors.grey[200],
      // ),
      body: SafeArea(
        child: BlocBuilder<RecognitionManagerCubit, RecognitionManagerState>(
          bloc: controller,
          builder: (context, state) {
            // If there are no results yet, display the name.
            final results = state.results.isEmpty ? placeholders.charList : state.results;
            final mostRecent = state.comparator == null ? '字' : state.comparator.toString();
            final int score = getScore(state.results);

            return Column(
              children: [
                Expanded(
                  child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            color: const Color.fromARGB(255, 108, 108, 108),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                controller.clearAll();
                              },
                              child: const Icon(
                                Icons.arrow_back,
                                color: Color.fromARGB(255, 221, 221, 221),
                              ),
                            ),
                          ),

                          // The USER CHARACTER LIST
                          Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          return SingleChildScrollView(
                                            reverse: results.length > 25 ? true : false,
                                            child: Wrap(
                                              children: [
                                                ...results.map((e) => UsersCharacterListButton(
                                                      character: e,
                                                      config: widget.config,
                                                    )),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // BUTTONS AT TOP RIGHT HAND CORNER
                          Align(
                            alignment: Alignment.topCenter,
                            child: _topRightButtons(score),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                // The black middle button contains the most recent inputted kanji
                // which is then compared against the user's next input
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PunctuationButton(
                        sign: '、',
                        onSubmit: () => controller.validateCharacter('、'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        child: BlackComparisonCharacterButton(character: mostRecent, config: widget.config),
                      ),
                      PunctuationButton(
                        sign: '。',
                        onSubmit: () => controller.validateCharacter('。'),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final character = state.candidates.isEmpty ? placeholders.recognition : state.candidates;
                      final width = constraints.maxWidth;
                      int numChars = width ~/ 60; // manage number of guesses displayed to stop overflow.
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...character.take(numChars).map(
                                (e) => MLRecognizedCharacterButton(
                                  character: e,
                                  onSubmit: () => controller.validateCharacter(e),
                                ),
                              ),
                        ],
                      );
                    },
                  ),
                ),
                InkInput(controller: controller),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _topRightButtons(int score) => Column(
        children: [
          if (score == 0)
            const IgnorePointer(
              child: Opacity(
                opacity: 0,
                child: InfoButton(text: "何"),
              ),
            ),
          if (score != 0) ...[
            const SizedBox(height: 8),
            Container(
              width: 45,
              height: 45,
              color: const Color.fromARGB(255, 49, 49, 49),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  score.toString(),
                  style: TextStyle(
                    fontSize: (score > 99) ? 15 : 25,
                    color: const Color.fromARGB(255, 214, 214, 214),
                    height: 1.26,
                  ),
                ),
              ),
            ),
          ],
        ],
      );
}
