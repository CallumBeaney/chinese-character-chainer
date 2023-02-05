import 'package:flutter/material.dart' hide Ink;
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import './activity_indicator/activity_indicator.dart';
import 'locator.dart';

Future<void> checkAndDownloadModel(String model, DigitalInkRecognizerModelManager manager) async {
  final bool response = await manager.isModelDownloaded(model);
  // print("\n\n_____Language Model status: $response");  // for debugging purposes
  if (response == false) {
    // print('_____Model Not Downloaded; downloading');  // for debugging purposes

    // TODO:
    //Toast().show('Downloading model...', locator<DigitalInkRecognizerModelManager>().downloadModel('ja').then((value) => value ? 'success' : 'failed'), context, this);

    final result = await manager.downloadModel(model).then((value) => value ? 'successfully downloaded!' : 'failed to download the language model');
    // print("_____download status: $result \n\n");  // for debugging purposes
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  checkAndDownloadModel('ja', locator.get<DigitalInkRecognizerModelManager>());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DigitalInkView(),
    );
  }
}

class DigitalInkView extends StatefulWidget {
  @override
  State<DigitalInkView> createState() => _DigitalInkViewState();
}

class _DigitalInkViewState extends State<DigitalInkView> {
  // Core variable declarations
  final Ink _ink = Ink();
  List<StrokePoint> _points = [];
  String _recognizedText = '';

  @override
  void dispose() {
    // ORIGINAL _digitalInkRecognizer.close();
    locator<DigitalInkRecognizer>().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 55, title: const Text('連想漢字蝶番')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
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
                  size: Size.infinite,
                ),
              ),
            ),
            if (_recognizedText.isNotEmpty)
              Text(
                'Candidates: $_recognizedText',
                style: const TextStyle(fontSize: 23),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ElevatedButton(
                  //   onPressed: _recogniseText,
                  //   child: Text('Read Text'),
                  // ),
                  ElevatedButton(
                    onPressed: _clearPad,
                    child: const Text('Clear Pad'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ElevatedButton(
                  //   onPressed: _isModelDownloaded,
                  //   child: Text('Check Model'),
                  // ),
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
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _clearPad() {
    setState(() {
      _ink.strokes.clear();
      _points.clear();
      _recognizedText = '';
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
      // ORIGINAL: final candidates = await _digitalInkRecognizer.recognize(_ink);
      final candidates = await locator<DigitalInkRecognizer>().recognize(_ink);
      _recognizedText = '';
      for (final candidate in candidates) {
        _recognizedText += '\n${candidate.text}';
      }
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }
}

class Signature extends CustomPainter {
  Ink ink;

  Signature({required this.ink});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
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
