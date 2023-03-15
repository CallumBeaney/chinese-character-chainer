import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:rensou_flutter/dictionary.dart';
import 'package:rensou_flutter/locator.dart';
import 'package:rxdart/rxdart.dart';

part 'recognition_manager_state.dart';

class RecognitionManagerCubit extends Cubit<RecognitionManagerState> {
  RecognitionManagerCubit() : super(RecognitionManagerState.initial);

  // Empty ML recognition candidates row
  void clearCandidates() => emit(state.copyWith(candidates: []));

  Stream<bool> get clearTriggerStream => stream
      .map((e) => e.results.length)
      .bufferCount(2, 1)
      .map((e) => e.first != e.last);

  Future<void> recogniseText(Ink ink) async {
    try {
      final List<RecognitionCandidate> candidates =
          await locator<DigitalInkRecognizer>().recognize(
              ink); // ML package .recognise() function invoked, returns list of guesses of user input
      final List<String> candidatesString = candidates
          .where((e) => dictionary.containsKey(e.text))
          .map((e) => e.text)
          .toList(); // Strip that guess list of non-valid characters e.g. romaji, katakana, */!-# etc
      emit(state.copyWith(candidates: candidatesString));
    } catch (e) {
      // todo: error thing
    }
  }

  void validateKanji(String newKanji) {
    final dictionary = locator<Dictionary>();
    final String? previousKanji = state.comparator;

    if (previousKanji == newKanji) {
      return;
    }

    if (newKanji == '。' || newKanji == '、') {
      emit(state.addResult(newKanji));
      return;
    }
    if (previousKanji == '。' || previousKanji == '、') {
      emit(state.addResult(newKanji));
      return;
    }

    List<String> previousKanjiRadicals =
        dictionary[previousKanji]?['radicals']?.split(',') ?? [];
    List<String> newKanjiRadicals =
        dictionary[newKanji]?['radicals']?.split(',') ?? [];

    if (previousKanji == null) {
      // User is submitting their first ever kanji -- let it pass!
      emit(state.addResult(newKanji));
      return;
    }

    if (newKanjiRadicals.any((e) => previousKanjiRadicals.contains(e)) ==
        false) {
      return;
      // TODO: change button colour!
    } else {
      emit(state.addResult(newKanji));
    }
  }
}
