import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rensou_flutter/buttons.dart';
import 'package:rensou_flutter/cubit/recognition_manager_cubit.dart';

import 'ink_input.dart';

class DigitalInkView extends StatefulWidget {
  const DigitalInkView({super.key});

  @override
  State<DigitalInkView> createState() => _DigitalInkViewState();
}

class _DigitalInkViewState extends State<DigitalInkView> {
  // final List<String> rensou = ['連', '想', '漢', '字', '蝶', '番'];
  final List<String> kanjiListPlaceholder = ['貴', '方', '之', '漢', '字', '列']; // "This is your kanji list"
  final List<String> recognitionKanjiPlaceholder = ['漢', '字', 'を', '書', 'い', 'て']; // "Write a kanji"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<RecognitionManagerCubit, RecognitionManagerState>(
          builder: (context, state) {
            // If there are no results yet, display the name.
            final results = state.results.isEmpty ? kanjiListPlaceholder : state.results;
            final mostRecent = state.comparator == null ? '字' : state.comparator.toString();
            return Column(
              // TODO: May need: https://stackoverflow.com/questions/51066628/fading-edge-listview-flutter
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          reverse: true,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...results.map((e) => ListKanjiButton(kanji: e)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // The black middle button contains the most recent inputted kanji
                //            which is then compared against the user's next input
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const PunctuationButton(sign: '、'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        child: ComparisonKanjiButton(kanji: mostRecent),
                      ),
                      const PunctuationButton(sign: '。'),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final kanji = state.candidates.isEmpty ? recognitionKanjiPlaceholder : state.candidates;
                      final width = constraints.maxWidth;
                      int numKanji = width ~/ 60; // manage number of guesses displayed to stop overflow.
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...kanji.take(numKanji).map(
                                (e) => RecognizedKanjiButton(
                                  kanji: e,
                                ),
                              ),
                        ],
                      );
                    },
                  ),
                ),
                const InkInput(),
              ],
            );
          },
        ),
      ),
    );
  }
}
