import 'dart:collection';

import 'dictionary.dart';

void main() {
  const nKanji = "貝", pKanji = "目";
  // TODO: Get previous kanji from user buttonpress of KanjiButton

  final result = validateKanji(nKanji, pKanji);

  if (result == true) {
    // TODO: code updating user's kanji list
  } else {
    // TODO: code kanji button failure state
  }
}

bool validateKanji(String newKanji, String previousKanji) {
  late final List<String>? previousKanjiRadicals;
  late final List<String>? newKanjiRadicals;

  if (dictionary.containsKey(newKanji) == false) {
    return false;
  } else {
    previousKanjiRadicals = dictionary[previousKanji]!['radicals']?.split(',');
    newKanjiRadicals = dictionary[newKanji]!['radicals']?.split(',');
  }

  if (newKanjiRadicals!.any((element) => previousKanjiRadicals!.contains(element)) == false) {
    return false;
  } else {
    return true;
  }
}
