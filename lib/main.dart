import 'package:flutter/material.dart' hide Ink;
import 'package:flutter/rendering.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import './activity_indicator/activity_indicator.dart';
import 'locator.dart';
import 'buttons.dart';
import 'dart:async';

Future<void> checkAndDownloadModel(String model, DigitalInkRecognizerModelManager manager) async {
  final bool response = await manager.isModelDownloaded(model);
  // print("\n\n_____Language Model status: $response"); // for debugging purposes
  if (response == false) {
    // print('_____Model Not Downloaded; downloading'); // for debugging purposes

    //Toast().show('Downloading model...', locator<DigitalInkRecognizerModelManager>().downloadModel('ja').then((value) => value ? 'success' : 'failed'), context, this);
    // final result =
    await manager.downloadModel(model).then((value) => value ? 'successfully downloaded!' : 'failed to download the language model');
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

class DigitalInkView extends StatefulWidget {
  const DigitalInkView({super.key});

  @override
  State<DigitalInkView> createState() => _DigitalInkViewState();
}

class _DigitalInkViewState extends State<DigitalInkView> {
  // Core variable declarations
  final Ink _ink = Ink();
  List<StrokePoint> _points = [];

  // String _recognizedText = '';   // For debugging
  // ignore: prefer_final_fields
  List<String> _recognizedKanji = [];

  double get _width => MediaQuery.of(context).size.width;
  final double _height = 360;

  final _candidatesStream = candidatesStream;

  @override
  void dispose() {
    // ORIGINAL _digitalInkRecognizer.close();
    locator<DigitalInkRecognizer>().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 30, title: const Text('連想漢字蝶番')),
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(child: SizedBox.expand(child: Text("todo"))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: LayoutBuilder(
                // TODO: kenkyuu
                builder: (context, constraints) {
                  return StreamBuilder(
                    stream: _candidatesStream,
                    builder: (context, snapshot) {
                      final kanji = snapshot.data ?? [];
                      final width = constraints.maxWidth;
                      int numKanji = width ~/ 65;
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
              height: _height,
              color: Colors.amber[100],
              child: GestureDetector(
                onPanStart: (DragStartDetails details) {
                  _ink.strokes.add(Stroke());
                },
                onPanUpdate: (DragUpdateDetails details) {
                  setState(() {
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
                  });
                },
                onPanEnd: (DragEndDetails details) {
                  _points.clear();
                  _recogniseText();
                  setState(() {});
                },
                child: CustomPaint(
                  painter: Signature(ink: _ink),
                  // size: (_width, _height),
                  size: Size.fromHeight(_height),
                ),
              ),
            ),
            if (_recognizedKanji.isNotEmpty) // TODO
              Text(
                // 'Candidates: $_recognizedText',  // 元版
                'Candidates: ${_recognizedKanji.where((e) => e.length == 1).toList()}', // TODO: introduce
                style: const TextStyle(fontSize: 23),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _clearPad,
                    child: const Text('消去', style: TextStyle(fontSize: 17)),
                  ),
                  ElevatedButton(
                    onPressed: _downloadModel,
                    child: const Text('Download'),
                  ),
                  ElevatedButton(
                    onPressed: _deleteModel,
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _clearPad() {
    setState(() {
      _ink.strokes.clear();
      _points.clear();
      // _recognizedText = '';
      _recognizedKanji.clear();
    });
  }

  // Future<void> _isModelDownloaded() async {
  //   Toast().show('Checking if model is downloaded...', locator<DigitalInkRecognizerModelManager>().isModelDownloaded(_language).then((value) => value ? 'downloaded' : 'not downloaded'), context, this);
  // }

  Future<void> _deleteModel() async {
    Toast().show('Deleting model...', locator<DigitalInkRecognizerModelManager>().deleteModel('ja').then((value) => value ? 'success' : 'failed'), context, this);
    // Toast().show('Deleting model...', _modelManager.deleteModel(_language).then((value) => value ? 'success' : 'failed'), context, this);
  }

  Future<void> _downloadModel() async {
    Toast().show('Downloading model...', locator<DigitalInkRecognizerModelManager>().downloadModel('ja').then((value) => value ? 'success' : 'failed'), context, this);
  }

  Future<void> _recogniseText() async {
    try {
      // final candidates = await _digitalInkRecognizer.recognize(_ink);  // 元版
      final candidates = await locator<DigitalInkRecognizer>().recognize(_ink);
      final candidatesString = candidates.map((e) => e.text).toList();
      _candidatesController.add(candidatesString);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }
}

// class ResultsButton extends StatelessWidget {
//   const ResultsButton({Key? key, required this.buttonText, required this.onTap}) : super(key: key);

//   final String buttonText;
//   final Function()? onTap;

//   @override
//   Widget build(BuildContext context) {
//     Center(child: InkWell(),)
//   }
// }

class Signature extends CustomPainter {
  Ink ink;

  Signature({required this.ink});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black87
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    for (final stroke in ink.strokes) {
      for (int i = 0; i < stroke.points.length - 1; i++) {
        final p1 = stroke.points[i];
        final p2 = stroke.points[i + 1];
        canvas.drawLine(Offset(p1.x.toDouble(), p1.y.toDouble()), Offset(p2.x.toDouble(), p2.y.toDouble()), paint);
      }
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) => true;
}

final StreamController<List<String>> _candidatesController = StreamController.broadcast();
Stream<List<String>> get candidatesStream => _candidatesController.stream;
