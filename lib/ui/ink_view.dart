import 'package:character_chainer/buttons.dart';
import 'package:character_chainer/cubit/recognition_manager_cubit.dart';
import 'package:character_chainer/model/language_config.dart';
import 'package:character_chainer/model/placeholders.dart';
import 'package:character_chainer/model/types.dart';
import 'package:character_chainer/ui/fade_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_to_words_chinese/number_to_words_chinese.dart';

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

  int getScoreAsInteger(List<String> answers) {
    return Set.from(answers).where((e) => dictionary.containsKey(e)).length;
  }

  // String getScoreAsChineseNumerals(List<String> answers) {
  //   return NumberToWordsChinese.convert(Set.from(answers).where((e) => dictionary.containsKey(e)).length);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<RecognitionManagerCubit, RecognitionManagerState>(
          bloc: controller,
          builder: (context, state) {
            // If there are no results yet, display the name.
            final results = state.results.isEmpty ? placeholders.charList : state.results;
            final mostRecent = state.comparator == null ? '字' : state.comparator.toString();
            final int scoreNum = getScoreAsInteger(state.results);
            // final String scoreChinese = getScoreAsChineseNumerals(state.results);

            return Column(
              children: [
                // TOP LEFT: NAVIGATION BACK BUTTON
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

                          // TOP MIDDLE: The USER CHARACTER LIST
                          Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          return FadeMask(
                                            startFade: 0.03,
                                            endFade: 0.98,
                                            child: SingleChildScrollView(
                                              reverse: results.length > 25 ? true : false,
                                              child: Wrap(
                                                children: [
                                                  ...results.map((e) => UsersCharacterListButton(
                                                        character: e,
                                                        config: widget.config,
                                                      )),
                                                ],
                                              ),
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
                          // SCORE COUNTER AT TOP RIGHT HAND CORNER
                          Align(
                            alignment: Alignment.topCenter,
                            // child: _topRightButtons(scoreNum, scoreChinese),
                            child: _topRightButtons(scoreNum),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                // The black middle button contains the most recent inputted kanji
                // which is then compared against the user's next input
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
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
                const SizedBox(height: 10),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _topRightButtons(int score) => Column(
        // Widget _topRightButtons(int score, String scoreChineseNumerals) => Column(
        children: [
          Opacity(
            opacity: score == 0 ? 0 : 1,
            child: Container(
              width: 45,
              height: 45,
              color: const Color.fromARGB(255, 49, 49, 49),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  // scoreChineseNumerals,
                  score.toString(),
                  style: TextStyle(
                    fontSize: (score > 99) ? 15 : 25,
                    color: const Color.fromARGB(255, 214, 214, 214),
                    height: 1.1,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}
