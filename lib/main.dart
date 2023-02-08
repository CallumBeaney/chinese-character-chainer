import 'package:flutter/material.dart' hide Ink;
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:rensou_flutter/digital_ink_view.dart';
import 'locator.dart';
import 'dart:async';

Future<void> checkAndDownloadModel(
    String model, DigitalInkRecognizerModelManager manager) async {
  final bool response = await manager.isModelDownloaded(model);
  // print("\n\n_____Language Model status: $response"); // for debugging purposes
  if (response == false) {
    // print('_____Model Not Downloaded; downloading'); // for debugging purposes

    //Toast().show('Downloading model...', locator<DigitalInkRecognizerModelManager>().downloadModel('ja').then((value) => value ? 'success' : 'failed'), context, this);
    // final result =
    await manager.downloadModel(model).then((value) => value
        ? 'successfully downloaded!'
        : 'failed to download the language model');
    // print("_____download status: $result \n\n"); // for debugging purposes
  }
}

// TODO: Listview for RButtons

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  checkAndDownloadModel('ja', locator.get<DigitalInkRecognizerModelManager>());
  locator.get<DigitalInkRecognizer>();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DigitalInkView(),
    );
  }
}

final StreamController<List<String>> candidatesController =
    StreamController.broadcast();
Stream<List<String>> get candidatesStream => candidatesController.stream;
