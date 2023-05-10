import 'package:flutter/material.dart';

class InkControls extends StatelessWidget {
  final VoidCallback onClear;
  const InkControls({super.key, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 53,
      height: 35,
      color: const Color.fromARGB(255, 108, 108, 108),
      // margin: const EdgeInsets.only(top: 10.0),
      child: TextButton(
        onPressed: onClear,
        child: const Text(
          '消去',
          style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 221, 221, 221), height: 1.2 /*height here handles vertical alignment*/),
        ),
      ),
    );
  }
}
