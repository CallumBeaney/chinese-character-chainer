import 'package:get_it/get_it.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'cubit/recognition_manager_cubit.dart';

typedef Dictionary = Map<String, Map<String, String?>>;

final locator = GetIt.instance;

RecognitionManagerCubit recognitionManager() => locator.get<RecognitionManagerCubit>();
// TODO: instantiate LanguageManagerCubit singleton & possibly DIR receiving the langcode like above getter fn()

void setup() {
  locator.registerLazySingleton<DigitalInkRecognizerModelManager>(() => DigitalInkRecognizerModelManager());

  // TODO: find a way to make this languageCode configurable by State monitoring
  // locator.registerLazySingleton<DigitalInkRecognizer>(() => DigitalInkRecognizer(languageCode: 'jp'));

  // locator.registerLazySingleton<Dictionary>(() => jp_dict);
  locator.registerLazySingleton<RecognitionManagerCubit>(() => RecognitionManagerCubit());
}
