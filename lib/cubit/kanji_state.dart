part of 'kanji_cubit.dart';

class KanjiState {
  final String? newInputtedKanji;
  final String? lastInputtedKanji;

  const KanjiState({
    required this.newInputtedKanji,
    required this.lastInputtedKanji,
  });

  static const initial = KanjiState(newInputtedKanji: null, lastInputtedKanji: null);
}
