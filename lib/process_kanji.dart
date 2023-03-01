import 'locator.dart';

//    All of this to be moved into kanji_cubit class

bool validateKanji(String newKanji, String previousKanji) {
  final List<String>? previousKanjiRadicals;
  final List<String>? newKanjiRadicals;

  if (locator<Dictionary>().containsKey(newKanji) == false) {
    return false;
  } else {
    previousKanjiRadicals = locator<Dictionary>()[previousKanji]!['radicals']?.split(',');
    newKanjiRadicals = locator<Dictionary>()[newKanji]!['radicals']?.split(',');
  }
  if (newKanjiRadicals!.any((element) => previousKanjiRadicals!.contains(element)) == false) {
    return false;
  } else {
    return true;
  }
}

// For Debug
// void main() { 
//   setup();
//   final bool result = validateKanji("貝", "目");
//   print(result);
// }