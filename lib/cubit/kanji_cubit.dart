// // import 'package:bloc/bloc.dart';
// // import 'package:rensou_flutter/locator.dart';

// // part 'kanji_state.dart';

// // class KanjiCubit extends Cubit<KanjiState> {
// //   KanjiCubit() : super(KanjiState.initial);

//   void validateKanji(String newKanji, String previousKanji) {
//     late final List<String> previousKanjiRadicals;
//     late final List<String> newKanjiRadicals;
//     final dict = locator<Dictionary>();

//     if (dict.containsKey(newKanji) == false) {
//       // FAILURE: Recognition button turn Red
//       return false;
//     } else {
//       // SUCCESS: check radicals
//       previousKanjiRadicals = dict[previousKanji]!['radicals']?.split(',') ?? [];
//       newKanjiRadicals = dict[newKanji]!['radicals']?.split(',') ?? [];
//     }

//     if (newKanjiRadicals.any((e) => previousKanjiRadicals.contains(e)) == false) {
//       return false;
//       // FAILURE: Recognition button turn Red
//     } else {
//       return true;
//       // SUCCESS: empty all Recognition buttons, turn Grey if any Red, send 'newKanji' to user kanji list button column.
//     }
//   }
// }
