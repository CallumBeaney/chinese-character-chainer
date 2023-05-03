import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:rensou_flutter/jp_dictionary.dart';
import 'package:rensou_flutter/locator.dart';
import 'package:rensou_flutter/zh_simp_dictionary.dart';
import 'package:rensou_flutter/zh_trad_dictionary.dart';

typedef Dictionary = Map<String, Map<String, String?>>;

// const languageOptions = {
//   "japanese": "ja",
//   "traditional": "zh-TW",
//   "simplified": "zh-CN",
// };

// CODES: https://developers.google.com/ml-kit/vision/digital-ink-recognition/base-models

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
  locator.registerLazySingleton<DigitalInkRecognizer>(() => DigitalInkRecognizer(languageCode: language));

  // Register Dictionary type Map in singleton
  switch (language) {
    case "ja":
      {
        locator.registerLazySingleton<Dictionary>(() => jp_dict);
      }
      break;

    case "zh-Hani-HK":
      {
        locator.registerLazySingleton<Dictionary>(() => zh_trad_dict);
      }
      break;

    case "zh-Hani-CN":
      {
        locator.registerLazySingleton<Dictionary>(() => zh_simp_dict);
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
