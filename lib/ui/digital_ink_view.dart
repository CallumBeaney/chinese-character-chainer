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
  double get _width => MediaQuery.of(context).size.width;
  final double canvasHeight = 300;

  // final List<String> rensou = ['連', '想', '漢', '字', '蝶', '番'];
  final List<String> kanjiListPlaceholder = ['此', 'は', '貴', '方', '之', '漢', '字', '列'];
  final List<String> kanjiPlaceholder = ['漢', '字', 'を', '書', 'い', 'て'];
  // 貴方の漢字列

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(toolbarHeight: 45, title: const Text('連想漢字蝶番')),
      body: SafeArea(
        child: BlocBuilder<RecognitionManagerCubit, RecognitionManagerState>(
          builder: (context, state) {
            // If there are no results yet, display the name.
            final results = state.results.isEmpty ? kanjiListPlaceholder : state.results;
            // ignore: prefer_if_null_operators
            final mostRecent = state.comparator == null ? '字' : state.comparator.toString();
            return Column(
              children: [
                // const Expanded(child: SizedBox.expand(child: Text("todo"))), // TODO upper area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ComparisonKanjiButton(kanji: mostRecent),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: LayoutBuilder(
                    // TODO: research LB vs SB
                    builder: (context, constraints) {
                      final kanji = state.candidates.isEmpty ? kanjiPlaceholder : state.candidates;
                      final width = constraints.maxWidth;
                      int numKanji = width ~/ 60; // manage number of guesses displayed to stop overflow.
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...kanji.take(numKanji).map(
                                (e) => RecognizedKanjiButton(
                                  kanji: e,
                                ),
                              ), // Future: possibly LayoutBuilder required
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
