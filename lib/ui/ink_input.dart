import 'dart:async';
import 'package:flutter/material.dart' hide Ink;
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:character_chainer/cubit/recognition_manager_cubit.dart';
import 'package:character_chainer/painter.dart';

import 'ink_controls.dart';

class InkInput extends StatefulWidget {
  final RecognitionManagerCubit controller;
  const InkInput({required this.controller, super.key});

  @override
  State<InkInput> createState() => _InkInputState();
}

class _InkInputState extends State<InkInput> {
  final double canvasHeight = 330;

  final Ink _ink = Ink();
  List<StrokePoint> _points = [];

  // This stream-related code, as used in RecognitionManagerCubit, is used to clear the canvas once the user presses a button output by the ML-kit's handwriting recognition operation. Without this, it won't work!
  late final StreamSubscription<bool> _clearTriggerSub;

  @override
  void initState() {
    _clearTriggerSub = widget.controller.clearTriggerStream.listen(_onClearTrigger);
    super.initState();
  } // _cTS must be housed in initState() or the listener will not listen

  void _onClearTrigger(bool trigger) {
    if (trigger) {
      _onClear(false);
    }
  }

  @override
  void dispose() {
    _clearTriggerSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Stack(
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
        SizedBox(
          width: width,
          height: canvasHeight,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: InkControls(onClear: _onClear),
          ),
        ),
      ],
    );
  }

  void _onRecognise() {
    setState(() {
      _points.clear();
    });
    widget.controller.recogniseText(_ink);
  }

  void _onClear([bool clearCandidates = true]) {
    setState(() {
      _ink.strokes.clear(); // Co-ordinate values
      _points.clear(); // Visual representation on the canvas
    });
    if (clearCandidates) {
      widget.controller.clearCandidates();
    }
  }
}
