import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:rensou_flutter/dictionary.dart';
import 'package:rensou_flutter/locator.dart';

part 'recognition_manager_state.dart';

class RecognitionManagerCubit extends Cubit<RecognitionManagerState> {
  RecognitionManagerCubit() : super(RecognitionManagerState.initial);

  Future<void> recogniseText(Ink ink) async {
    try {
      final List<RecognitionCandidate> candidates = await locator<DigitalInkRecognizer>().recognize(ink);
      final List<String> candidatesString = candidates.where((e) => dictionary.containsKey(e.text)).map((e) => e.text).toList();
      emit(state.copyWith(candidates: candidatesString));
    } catch (e) {
      // todo: error thing
    }
  }

  void clearCandidates() => emit(state.copyWith(candidates: []));
}


// In Cubit need function called when user taps button (yingai void)
// i.e. when Knajitapped