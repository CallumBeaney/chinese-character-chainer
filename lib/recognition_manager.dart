import 'package:bloc/bloc.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';

class RecognitionManager extends Cubit<List<String>> {
  RecognitionManager() : super(const []);

  final Ink _ink = Ink();
}
