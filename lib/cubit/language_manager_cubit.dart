import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:rensou_flutter/jp_dictionary.dart';
import 'package:rensou_flutter/locator.dart';
import 'package:rensou_flutter/zh_simp_dictionary.dart';
import 'package:rensou_flutter/zh_trad_dictionary.dart';

part 'language_manager_state.dart';

typedef Dictionary = Map<String, Map<String, String?>>;

// BCP-47 Codes from https://developers.google.com/ml-kit/vision/digital-ink-recognition/base-models?hl=en#text
const language_options = {
  "japanese": "jp",
  "traditional": "zh-TW",
  "simplified": "zh-CN",
  // "japanese": {
  //   "code": "jp",
  //   "dict": jp_dict,
  // },
  // "traditional": {
  //   "code": "zh-TW",
  //   "dict": zh_trad_dictionary,
  // },
  // /* zh-Hani-TW */
  // "simplified": {
  //   "code": "zh-CN",
  //   "dict": zh_simp_dict,
  // },
};

class LanguageManagerCubit extends Cubit<LanguageManagerState> {
  LanguageManagerCubit() : super(LanguageManagerState.initial);

  void update(String lang, String dict) => emit(state.copyWith(language: lang, dictionary: dict));

  void changeLanguage(String language) {
    bool checkDict = locator.isRegistered<Dictionary>();
    if (checkDict == true) {
      locator.unregister<Dictionary>();
    }

    bool checkRecognizer = locator.isRegistered<DigitalInkRecognizer>();
    if (checkRecognizer == true) {
      locator<DigitalInkRecognizer>().close();
      locator.unregister<DigitalInkRecognizer>();
    }

    // Register Ink Recognizer in singleton
    locator.registerLazySingleton<DigitalInkRecognizer>(() => DigitalInkRecognizer(languageCode: language_options[language]!));

    // Register Dictionary type Map in singleton
    switch (language) {
      case "japanese":
        {
          locator.registerLazySingleton(() => jp_dict);
        }
        break;

      case "traditional":
        {
          locator.registerLazySingleton(() => zh_trad_dict);
        }
        break;

      case "simplified":
        {
          locator.registerLazySingleton(() => zh_simp_dict);
        }
        break;
    }

    checkDict = locator.isRegistered<Dictionary>();
    if (checkDict == false) {
      // There's a problem!
    }

    // TODO: check w alex about this Object? return type issues WRT custom map objects etc -- is the reason for using the Switch below
    // locator.registerLazySingleton<Dictionary>(() => language_options[language]['code']);
  }
}
