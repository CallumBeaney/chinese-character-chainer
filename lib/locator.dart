import 'package:get_it/get_it.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'cubit/recognition_manager_cubit.dart';
import 'dictionary.dart';

typedef Dictionary = Map<String, Map<String, String?>>;

final locator = GetIt.instance;

RecognitionManagerCubit recognitionManager() => locator.get<RecognitionManagerCubit>();

void setup() {
  locator.registerLazySingleton<DigitalInkRecognizerModelManager>(() => DigitalInkRecognizerModelManager());
  locator.registerLazySingleton<DigitalInkRecognizer>(() => DigitalInkRecognizer(languageCode: 'ja'));

  locator.registerLazySingleton<Dictionary>(() => dictionary);
  locator.registerLazySingleton<RecognitionManagerCubit>(() => RecognitionManagerCubit());
}
