import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Ink; // prevent clashes with ML Kit class
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:rensou_flutter/painter.dart';
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
      // theme: ThemeData(
      //   textButtonTheme: TextButton.styleFrom(foregroundColor: Colors.green),
      // ),
      home: DigitalInkView(),
    );
  }
}

class DigitalInkView extends StatefulWidget {
  const DigitalInkView({super.key});

  @override
  State<DigitalInkView> createState() => _DigitalInkViewState();
}

class _DigitalInkViewState extends State<DigitalInkView> {
  // Core variable declarations
  final Ink _ink = Ink();
  List<StrokePoint> _points = [];

  double get _width => MediaQuery.of(context).size.width;
  final double canvasHeight = 350;

  final _candidatesStream = candidatesStream;

  @override
  void dispose() {
    locator<DigitalInkRecognizer>().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(toolbarHeight: 45, title: const Text('連想漢字蝶番')),
      body: SafeArea(
        child: Column(
          children: [
            // const Expanded(child: SizedBox.expand(child: Text("todo"))), // TODO upper area

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return StreamBuilder(
                      stream: _candidatesStream,
                      builder: (context, snapshot) {
                        final List<String> rensou = ['連', '想', '漢', '字', '蝶', '番', '漢', '字', '蝶', '番', '漢', '字', '蝶', '番'];
                        // final height = int(constraints.maxHeight);
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...rensou.map((e) => KanjiButton(kanji: e)),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: LayoutBuilder(
                // TODO: research LB vs SB
                builder: (context, constraints) {
                  return StreamBuilder(
                    stream: _candidatesStream,
                    builder: (context, snapshot) {
                      final kanji = snapshot.data ?? ['漢', '字', 'を', 'か', 'い', 'て'];
                      final width = constraints.maxWidth;
                      int numKanji = width ~/ 65; // manages the display to stop overflow.
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...kanji.take(numKanji).map((e) => KanjiButton(kanji: e)), // Future: possibly LayoutBuilder required
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              // decoration: BoxDecoration(border: Border.all()),   // If use, can't use color:...
              width: _width,
              height: canvasHeight,
              color: Colors.grey[300],
              child: GestureDetector(
                onPanStart: (DragStartDetails details) {
                  _ink.strokes.add(Stroke());
                },
                onPanUpdate: (DragUpdateDetails details) {
                  setState(
                    () {
                      final RenderObject? object = context.findRenderObject();
                      final localPosition = (object as RenderBox?)?.globalToLocal(details.localPosition);
                      if (localPosition != null) {
                        _points = List.from(_points)
                          ..add(StrokePoint(
                            x: localPosition.dx,
                            y: localPosition.dy,
                            t: DateTime.now().millisecondsSinceEpoch,
                          ));
                      }
                      if (_ink.strokes.isNotEmpty) {
                        _ink.strokes.last.points = _points.toList();
                      }
                    },
                  );
                },
                onPanEnd: (DragEndDetails details) {
                  _points.clear();
                  _recogniseText();
                  setState(() {});
                },
                child: CustomPaint(
                  painter: Signature(ink: _ink),
                  // size: (_width, _height),
                  // size: Size.fromHeight(_height),
                  size: Size.fromHeight(canvasHeight),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 66,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: _clearPad,
                      child: const Text('消去', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  // ElevatedButton(
                  //   onPressed: _downloadModel,
                  //   child: const Text('Download'),
                  // ),
                  // ElevatedButton(
                  //   onPressed: _deleteModel,
                  //   child: const Text('Delete'),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearPad() {
    setState(() {
      _ink.strokes.clear(); // Co-ordinate values
      _points.clear(); // Visual representation on the canvas
      // _recognizedKanji.clear();
    });
  }

  // Future<void> _isModelDownloaded() async {
  //   Toast().show('Checking if model is downloaded...', locator<DigitalInkRecognizerModelManager>().isModelDownloaded(_language).then((value) => value ? 'downloaded' : 'not downloaded'), context, this);
  // }
  // Future<void> _deleteModel() async {
  //   Toast().show('Deleting model...', locator<DigitalInkRecognizerModelManager>().deleteModel('ja').then((value) => value ? 'success' : 'failed'), context, this);
  //   // Toast().show('Deleting model...', _modelManager.deleteModel(_language).then((value) => value ? 'success' : 'failed'), context, this);
  // }
  // Future<void> _downloadModel() async {
  //   Toast().show('Downloading model...', locator<DigitalInkRecognizerModelManager>().downloadModel('ja').then((value) => value ? 'success' : 'failed'), context, this);
  // }

  Future<void> _recogniseText() async {
    try {
      final List<RecognitionCandidate> candidates = await locator<DigitalInkRecognizer>().recognize(_ink);
      final List<String> candidatesString = candidates.where((e) => e.text.length == 1).map((e) => e.text).toList();
      _candidatesController.add(candidatesString);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }
}


// Stream for User's Choice
// final StreamController<List<String>> _resultsController = StreamController.broadcast();
// Stream<List<String>> get resultsController => _resultsController.stream;

