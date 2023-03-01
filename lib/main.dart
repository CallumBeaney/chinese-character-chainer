// ignore_for_file: unused_import, unnecessary_import

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Ink; // prevent clashes with ML Kit class
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:rensou_flutter/cubit/recognition_manager_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rensou_flutter/painter.dart';
import 'package:rensou_flutter/ui/digital_ink_view.dart';
import './activity_indicator/activity_indicator.dart';
import 'locator.dart'; // Singleton
import 'buttons.dart';
import 'dart:async';

Future<void> checkAndDownloadModel(String model, DigitalInkRecognizerModelManager manager) async {
  final bool response = await manager.isModelDownloaded(model);
  if (response == false) {
    // ORIGINAL: Toast().show('Downloading model...', locator<DigitalInkRecognizerModelManager>().downloadModel('ja').then((value) => value ? 'success' : 'failed'), context, this);
    // ignore: unused_local_variable
    final result = await manager.downloadModel(model).then((value) => value ? 'successfully downloaded!' : 'failed to download the language model');
  }
}

// // Stream for Text Recognition candidates
final StreamController<List<String>> _candidatesController = StreamController.broadcast();
Stream<List<String>> get candidatesStream => _candidatesController.stream;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  await checkAndDownloadModel('ja', locator.get<DigitalInkRecognizerModelManager>()); //TODO: note change
  locator.get<DigitalInkRecognizer>();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => RecognitionManagerCubit()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(
        //   textButtonTheme: TextButton.styleFrom(foregroundColor: Colors.green),
        // ),
        home: DigitalInkView(),
      ),
    );
  }
}
