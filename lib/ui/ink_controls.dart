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
          SizedBox(
            width: 66,
            height: 40,
            child: ElevatedButton(
              onPressed: onClear,
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
    );
  }
}
