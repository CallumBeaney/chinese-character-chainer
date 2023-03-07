import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:rensou_flutter/dictionary.dart';
import 'package:rensou_flutter/locator.dart';

part 'recognition_manager_state.dart';

class RecognitionManagerCubit extends Cubit<RecognitionManagerState> {
  RecognitionManagerCubit() : super(RecognitionManagerState.initial);

  // Empty ML recognition candidates row
  void clearCandidates() => emit(state.copyWith(candidates: []));

  Future<void> recogniseText(Ink ink) async {
    try {
      // ML package .recognise() function invoked, returns list of guesses of user input
      final List<RecognitionCandidate> candidates = await locator<DigitalInkRecognizer>().recognize(ink);
      // Strip that guess list of non-valid characters e.g. romaji, katakana, */!-# etc
      final List<String> candidatesString = candidates.where((e) => dictionary.containsKey(e.text)).map((e) => e.text).toList();
      emit(state.copyWith(candidates: candidatesString));
    } catch (e) {
      // todo: error thing
    }
  }

  void validateKanji(String newKanji) {
    final String? previousKanji = state.comparator;
    List<String>? previousKanjiRadicals;
    List<String>? newKanjiRadicals;

    if (previousKanji == null) {
      print('here');
      // User is submitting their first ever kanji -- let it pass!
      locator<List<String>>().add(newKanji);
      emit(state.copyWith(results: locator<List<String>>()));
    }

    previousKanjiRadicals = locator<Dictionary>()[previousKanji]?['radicals']?.split(',');
    newKanjiRadicals = locator<Dictionary>()[newKanji]?['radicals']?.split(',');

    if (newKanjiRadicals!.any((element) => previousKanjiRadicals!.contains(element)) == false) {
      print('error yo');
      // TODO: change button colour!
    } else {
      locator<List<String>>().add(newKanji);
      emit(state.copyWith(results: locator<List<String>>()));
    }
  }

  // TODO: https://pub.dev/packages/get_it#resetting-lazysingletons
}

// In Cubit need function called when user taps button (yingai void)
// i.e. when Knajitapped
