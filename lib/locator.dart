import 'package:get_it/get_it.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';

final locator = GetIt.instance;

void setup() {
  // final String language = 'ja';
  locator.registerLazySingleton<DigitalInkRecognizerModelManager>(() => DigitalInkRecognizerModelManager());
  locator.registerLazySingleton<DigitalInkRecognizer>(() => DigitalInkRecognizer(languageCode: 'ja'));
}
