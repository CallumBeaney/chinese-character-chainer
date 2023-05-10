import 'package:flutter/material.dart' hide Ink; // prevent clashes with ML Kit class
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:character_chainer/ui/app_info_view.dart';
import 'package:character_chainer/ui/ink_view.dart';
import 'package:flutter/material.dart';
import 'package:character_chainer/ui/setup_view.dart';
import 'locator.dart'; // Singleton
import 'dart:async';
import 'model/model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup(); // Call singleton, init global language model manager for ink recognition ML KIT
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 1. Run this right when the app first starts
  @override
  void initState() {
    super.initState();
    // Check when the app is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkModelsDownloaded(context);
    });
    // initState is a State class's method that's called once and will run on opening
    // WidgetsBinding is a singleton class that binds existing widgets to the flutter Fw.
    // postframecallback will therefore register the checking function the very moment the app loads, but will be executed only once the UI is loaded
  }

  // 2. Check whether language models are downloaded. They cannot be packaged locally because Google.
  Future<void> _checkModelsDownloaded(context) async {
    // locator.get<DigitalInkRecognizerModelManager>().deleteModel('ja'); // for debugging

    // LANGUAGE CODES: https://developers.google.com/ml-kit/vision/digital-ink-recognition/base-models
    final bool jaCheck = await locator.get<DigitalInkRecognizerModelManager>().isModelDownloaded('ja');
    final bool zhCheck = await locator.get<DigitalInkRecognizerModelManager>().isModelDownloaded('zh-Hani-CN');
    final bool zhTrCheck = await locator.get<DigitalInkRecognizerModelManager>().isModelDownloaded('zh-Hani-TW');

    List<Future<bool>> awaitFutures = [];

    if (jaCheck == false || zhCheck == false || zhTrCheck == false) {
      // open a splash screen while downloading
      Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => const PopupPage(error: false)),
      );

      // Really, all 3 will be downloaded at once, but if 万が一 user's phone dies halfway through this operation, not doing this defensively would cause issues
      if (jaCheck == false || zhCheck == false || zhTrCheck == false) {
        if (jaCheck == false) {
          // done this way we ensure that the async operations return to `awaitFutures` and as such that the if statement checking its emptiness does not fail due to delayed return.
          Future<bool> jaFuture = locator.get<DigitalInkRecognizerModelManager>().downloadModel('ja');
          final bool jaResult = await jaFuture;
          awaitFutures.add(jaResult
              ? Future.value(true) /* successful */
              : Future.value(false) /* failure to DL */);
        }
        if (zhCheck == false) {
          Future<bool> zhFuture = locator.get<DigitalInkRecognizerModelManager>().downloadModel('zh-Hani-CN');
          final bool zhResult = await zhFuture;
          awaitFutures.add(zhResult ? Future.value(true) : Future.value(false));
        }
        if (zhTrCheck == false) {
          Future<bool> zhTrFuture = locator.get<DigitalInkRecognizerModelManager>().downloadModel('zh-Hani-TW');
          final bool zhTrResult = await zhTrFuture;
          awaitFutures.add(zhTrResult ? Future.value(true) : Future.value(false));
        }
      }
    }

    if (awaitFutures.isNotEmpty) {
      List<bool> downloadAttemptResults = await Future.wait(awaitFutures);
      // print(downloadAttemptResults); // should return [true, true, true]

      if (downloadAttemptResults.every((result) => result == true)) {
        Navigator.of(context).pop();
      } else {
        // navigate to an ERROR variant with a app exit button.
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => const PopupPage(error: true)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Home Page'),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.17),
              child: const Text(
                '漢字連鎖',
                style: TextStyle(
                  fontSize: 70,
                  shadows: [
                    Shadow(
                      blurRadius: 5,
                      color: Colors.grey,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(5),
                      width: 120,
                      height: 60,
                      color: const Color.fromARGB(255, 108, 108, 108),
                      child: TextButton(
                          onPressed: () =>
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const DigitalInkView(config: LanguageConfig.jp))),
                          child: const Text(
                            "日本語",
                            style: TextStyle(color: Color.fromARGB(255, 221, 221, 221), fontSize: 26, height: 1.2),
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      width: 120,
                      height: 60,
                      color: const Color.fromARGB(255, 108, 108, 108),
                      child: TextButton(
                          onPressed: () =>
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const DigitalInkView(config: LanguageConfig.zhSimp))),
                          child: const Text(
                            "简体字",
                            style: TextStyle(color: Color.fromARGB(255, 221, 221, 221), fontSize: 26, height: 1.2),
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      width: 120,
                      height: 60,
                      color: const Color.fromARGB(255, 108, 108, 108),
                      child: TextButton(
                          onPressed: () =>
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const DigitalInkView(config: LanguageConfig.zhTrad))),
                          child: const Text(
                            "繁體字",
                            style: TextStyle(color: Color.fromARGB(255, 221, 221, 221), fontSize: 26, height: 1.2),
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      width: 120,
                      height: 60,
                      color: const Color.fromARGB(255, 108, 108, 108),
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const AppInfoView()));
                          },
                          child: const Text(
                            "ABOUT",
                            style: TextStyle(color: Color.fromARGB(255, 221, 221, 221), fontSize: 23, height: 1.2),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.25), // add some padding below the buttons
          ],
        ),
      ),
    );
  }
}
