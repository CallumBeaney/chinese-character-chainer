import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:chinese_character_chainer/model/model.dart';
import 'package:rxdart/rxdart.dart';

part 'recognition_manager_state.dart';

class RecognitionManagerCubit extends Cubit<RecognitionManagerState> {
  final LanguageConfig config;
  late final recognizer = DigitalInkRecognizer(languageCode: config.code);

  RecognitionManagerCubit({required this.config}) : super(RecognitionManagerState.initial);

  // Empty ML recognition candidates row
  void clearCandidates() => emit(state.copyWith(candidates: []));

  void clearAll() => emit(state.copyWith(candidates: [], results: []));

  // This is important! This is used in ink_input.dart to auto-clear the Ink input canvas.
  Stream<bool> get clearTriggerStream => stream.map((e) => e.results.length).bufferCount(2, 1).map((e) => e.first != e.last);

  Future<void> recogniseText(Ink ink) async {
    try {
      final List<RecognitionCandidate> candidates =
          await recognizer.recognize(ink); // ML package .recognise() function invoked, returns list of guesses of user input
      final List<String> candidatesString = candidates
          .where((e) => config.dictionary.containsKey(e.text))
          .map((e) => e.text)
          .toList(); // Strip that guess list of non-valid characters e.g. romaji, katakana, */!-# etc
      emit(state.copyWith(candidates: candidatesString));
    } catch (e) {
      return;
    }
  }

  void validateCharacter(String newCharacter) {
    final String? previousCharacter = state.comparator;

    if (previousCharacter == newCharacter) {
      return;
    }

    if (previousCharacter == null && (newCharacter == '。' || newCharacter == '、' || !config.dictionary.containsKey(newCharacter))) {
      // The user is trying to enter e.g. hiragana or punctuation buttons for their first ever input -- ダメ！
      return;
    }
    if (previousCharacter == null && config.dictionary.containsKey(newCharacter)) {
      // User is submitting their first ever kanji/hanzi -- let it pass!
      emit(state.addResult(newCharacter));
      return;
    }

    // is user trying [ 。 、 。 、 。 、 ] ???
    if ((newCharacter == '。' && previousCharacter == '、') || (newCharacter == '、' && previousCharacter == '。')) {
      return;
    }

    // is user adding legitimate punctuation && there's already a kanji inputted?
    if (newCharacter == '。' || newCharacter == '、') {
      emit(state.addResult(newCharacter));
      return;
    }

    // is user adding chracter _after_ punctuation? In which case any valid character may be pushed.
    if ((previousCharacter == '。' || previousCharacter == '、') && config.dictionary.containsKey(newCharacter)) {
      emit(state.addResult(newCharacter));
      return;
    }

    List<String> prevCharRadicals = config.dictionary[previousCharacter]?['radicals']?.split(',') ?? [];
    List<String> newCharRadicals = config.dictionary[newCharacter]?['radicals']?.split(',') ?? [];

    if (newCharRadicals.any((e) => prevCharRadicals.contains(e)) == false) {
      return;
      // TODO ?: change button colour?
    } else {
      emit(state.addResult(newCharacter));
    }
  }
}
