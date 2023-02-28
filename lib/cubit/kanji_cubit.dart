import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rensou_flutter/locator.dart';

part 'kanji_state.dart';

class KanjiCubit extends Cubit<KanjiState> {
  KanjiCubit() : super(KanjiState(newInputtedKanji: null, lastInputtedKanji: null));

  bool validateKanji(String newKanji, String previousKanji) {
    late final List<String>? previousKanjiRadicals;
    late final List<String>? newKanjiRadicals;

    if (locator<Dictionary>().containsKey(newKanji) == false) {
      // ML Recognition button that was pressed to turn Red, not make any text changes
      return false;
    } else {
      previousKanjiRadicals = locator<Dictionary>()[previousKanji]!['radicals']?.split(',');
      newKanjiRadicals = locator<Dictionary>()[newKanji]!['radicals']?.split(',');
    }

    if (newKanjiRadicals!.any((element) => previousKanjiRadicals!.contains(element)) == false) {
      return false;
      // ML Recognition button that was pressed to turn Red, not make any text changes
    } else {
      return true;
      // ALL Recognition buttonS to empty, turn Grey if any Red, send 'newKanji' to user kanji list button column.
    }
  }
}
