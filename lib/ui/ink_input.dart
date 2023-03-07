import 'package:flutter/material.dart' hide Ink;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:rensou_flutter/cubit/recognition_manager_cubit.dart';
import 'package:rensou_flutter/painter.dart';

import 'ink_controls.dart';

class InkInput extends StatefulWidget {
  const InkInput({super.key});

  @override
  State<InkInput> createState() => _InkInputState();
}

class _InkInputState extends State<InkInput> {
  final double canvasHeight = 300;

  final Ink _ink = Ink();
  List<StrokePoint> _points = []; // TODO: singleton to access from digital_ink_view upon validation?

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          // decoration: BoxDecoration(border: Border.all()),   // If use, can't use color:...
          width: width,
          height: canvasHeight,
          color: Colors.grey[300],
          child: GestureDetector(
            onPanStart: (DragStartDetails details) {
              _ink.strokes.add(Stroke());
            },
            onPanUpdate: (DragUpdateDetails details) {
              setState(
                () {
                  _points = List.from(_points)
                    ..add(StrokePoint(
                      x: details.localPosition.dx,
                      y: details.localPosition.dy,
                      t: DateTime.now().millisecondsSinceEpoch,
                    ));

                  if (_ink.strokes.isNotEmpty) {
                    _ink.strokes.last.points = _points.toList();
                  }
                },
              );
            },
            onPanEnd: (_) => _onRecognise(),
            child: CustomPaint(
              painter: Signature(strokes: _ink.strokes),
              // size: Size(width, canvasHeight),
              // size: Size.fromHeight(_height),
              size: Size.fromHeight(canvasHeight),
            ),
          ),
        ),
        InkControls(onClear: _onClear)
      ],
    );
  }

  void _onRecognise() {
    setState(() {
      _points.clear();
    });
    BlocProvider.of<RecognitionManagerCubit>(context).recogniseText(_ink);
  }

  void _onClear() {
    setState(() {
      _ink.strokes.clear(); // Co-ordinate values
      _points.clear(); // Visual representation on the canvas
    });
    BlocProvider.of<RecognitionManagerCubit>(context).clearCandidates();
  }
}
