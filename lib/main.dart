import 'package:flutter/material.dart' hide Ink; // prevent clashes with ML Kit class
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rensou_flutter/ui/app_info_view.dart';
import 'package:rensou_flutter/ui/jp_ink_view.dart';
// import 'package:rensou_flutter/ui/home_view.dart';
import 'package:flutter/material.dart';
import 'package:rensou_flutter/ui/zh_simp_ink_view.dart';
import 'package:rensou_flutter/ui/zh_trad_ink_view.dart';
import 'package:rxdart/streams.dart';
import 'locator.dart'; // Singleton
import 'dart:async';
import 'locator_handler.dart';

// Must access
// Future<void> checkAndDownloadModel(String model, DigitalInkRecognizerModelManager manager) async {
//   final bool response = await manager.isModelDownloaded(model);
//   if (response == false) {
//     // ORIGINAL: Toast().show('Downloading model...', locator<DigitalInkRecognizerModelManager>().downloadModel('ja').then((value) => value ? 'success' : 'failed'), context, this);
//     // ignore: unused_local_variable
//     final result = await manager.downloadModel(model).then((value) => value ? 'successfully downloaded!' : 'failed to download the language model');
//   }
// }

// // Stream for Text Recognition candidates
// final StreamController<List<String>> _candidatesController = StreamController.broadcast();
// Stream<List<String>> get candidatesStream => _candidatesController.stream;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  // await checkAndDownloadModel('ja', locator.get<DigitalInkRecognizerModelManager>()); //TODO: functionality to change languages?
  // await checkAndDownloadModel('zh-Hani', locator.get<DigitalInkRecognizerModelManager>());
  // popup on first ever startup
  // locator.get<DigitalInkRecognizer>();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => recognitionManager()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(
        //   textButtonTheme: TextButton.styleFrom(foregroundColor: Colors.green),
        // ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _checkModelsDownloaded(context) async {
    // locator.get<DigitalInkRecognizerModelManager>().deleteModel('ja'); // for debugging
    // locator.get<DigitalInkRecognizerModelManager>().deleteModel('zh-Hani'); // for debugging
    final bool jaCheck = await locator.get<DigitalInkRecognizerModelManager>().isModelDownloaded('ja');
    final bool zhCheck = await locator.get<DigitalInkRecognizerModelManager>().isModelDownloaded('zh-Hani-CN');
    final bool zhTrCheck = await locator.get<DigitalInkRecognizerModelManager>().isModelDownloaded('zh-Hani-HK');

    if (jaCheck == false || zhCheck == false || zhTrCheck == FromCallableStream) {
      Navigator.of(context).push(
        // TODO: design PopupPage such that it listens for completion of downloads
        MaterialPageRoute(builder: (BuildContext context) => const PopupPage()),
      );
      if (jaCheck == false) {
        // ignore: unused_local_variable
        final bool result =
            await locator.get<DigitalInkRecognizerModelManager>().downloadModel('ja').then((value) => value ? true /* successful */ : false);
      }
      if (zhCheck == false) {
        // ignore: unused_local_variable
        final bool result = await locator.get<DigitalInkRecognizerModelManager>().downloadModel('zh-Hani-CN').then((value) => value ? true : false);
      }
      if (zhTrCheck == false) {
        // ignore: unused_local_variable
        final bool result = await locator.get<DigitalInkRecognizerModelManager>().downloadModel('zh-Hani-HK').then((value) => value ? true : false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Check the condition when the app is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkModelsDownloaded(context);
      // TODO: build language-specific recognisers based on menu button pushed
      // locator.get<DigitalInkRecognizer>(); // TODO: uncomment + remove buttons below to check if works.
    });
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
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
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
                          onPressed: () {
                            changeLanguage("ja");
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const DigitalInkView()));
                          },
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
                          onPressed: () {
                            changeLanguage("zh-Hani-CN");
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ZhSimpInkView()));
                          },
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
                          onPressed: () {
                            changeLanguage("zh-Hani-HK");
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ZhTradInkView()));
                          },
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

// Navigator.push(context, MaterialPageRoute(builder: (context) => KanjiInfoView(kanji: kanji)));

class PopupPage extends StatelessWidget {
  const PopupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First-Time Setup'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Padding(
              padding: EdgeInsets.all(50),
              child: Text('Installing language models for this app.\n\nOnce this download is complete, this app can be operated fully offline.'),
            ),
          ],
        ),
      ),
    );
  }
}
