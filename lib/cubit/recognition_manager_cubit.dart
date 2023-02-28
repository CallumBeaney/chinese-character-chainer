import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' hide Ink; // prevent clashes with ML Kit class
import 'package:meta/meta.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:rensou_flutter/locator.dart';

part 'recognition_manager_state.dart';

class RecognitionManagerCubit extends Cubit<List<String>> {
  RecognitionManagerCubit() : super(const []);

  final Ink _ink = Ink();
  List<StrokePoint> _points = [];

  Future<void> _recogniseText(context) async {
    try {
      final List<RecognitionCandidate> candidates = await locator<DigitalInkRecognizer>().recognize(_ink);
      final List<String> candidatesString = candidates.where((e) => e.text.length == 1).map((e) => e.text).toList();
      //_candidatesController.add(candidatesString);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }
}
