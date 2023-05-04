import 'package:flutter/material.dart' hide Ink; // prevent clashes with ML Kit class
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:rensou_flutter/ui/app_info_view.dart';
import 'package:rensou_flutter/ui/ink_view.dart';
import 'package:flutter/material.dart';
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
  Future<void> _checkModelsDownloaded(context) async {
    // TODO: implement less cursed way of doing this.
    // Activity indicator may be viable alternative as per below:
    // Toast().show('Downloading model...', locator<DigitalInkRecognizerModelManager>().downloadModel('ja').then((value) => value ? 'success' : 'failed'), context, this);

    // locator.get<DigitalInkRecognizerModelManager>().deleteModel('ja'); // for debugging
    final bool jaCheck = await locator.get<DigitalInkRecognizerModelManager>().isModelDownloaded('ja');
    final bool zhCheck = await locator.get<DigitalInkRecognizerModelManager>().isModelDownloaded('zh-Hani-CN');
    final bool zhTrCheck = await locator.get<DigitalInkRecognizerModelManager>().isModelDownloaded('zh-Hani-TW');

    if (jaCheck == false || zhCheck == false || zhTrCheck == false) {
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
        final bool result = await locator.get<DigitalInkRecognizerModelManager>().downloadModel('zh-Hani-TW').then((value) => value ? true : false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Check when the app is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkModelsDownloaded(context);
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
