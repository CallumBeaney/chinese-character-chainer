import 'package:flutter/material.dart';

class InkControls extends StatelessWidget {
  final VoidCallback onClear;
  const InkControls({super.key, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 55,
            height: 35,
            color: Colors.grey[300],
            margin: const EdgeInsets.only(top: 3.0),
            child: TextButton(
              onPressed: onClear,
              child: const Text(
                '消去',
                style: TextStyle(fontSize: 18, color: Colors.black, height: 1.2),
              ),
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
    );
  }
}
