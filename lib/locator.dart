import 'package:get_it/get_it.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';

// This is a singleton setup function.
final locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<DigitalInkRecognizerModelManager>(() => DigitalInkRecognizerModelManager());
}
