import 'package:flutter/material.dart';

// TODO ?: try implement Alex's fade thing

class FadeMask extends StatelessWidget {
  final Widget child;
  final double? startFade;
  final double? endFade;
  const FadeMask({
    super.key,
    required this.child,
    this.startFade = 0.02,
    this.endFade = 0.9,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            if (startFade != null) Colors.white,
            Colors.transparent,
            Colors.transparent,
            if (endFade != null) Colors.white,
          ],
          stops: [
            0.0,
            if (startFade != null) startFade!,
            if (endFade != null) endFade!,
            1.0,
          ], // 10% purple, 80% transparent, 10% purple
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: child,
    );
  }
}
