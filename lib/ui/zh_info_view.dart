// ignore_for_file: prefer_null_aware_operators

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:rensou_flutter/buttons.dart';
import 'package:rensou_flutter/locator.dart';
import 'package:rensou_flutter/ui/theme_data.dart';

class HanziInfoView extends StatelessWidget {
  const HanziInfoView({Key? key, required this.kanji})
      : super(
          key: key,
        );

  final String kanji;

  get dictionary => locator<Dictionary>();

  // These will _never_ be NULL
  String get pinyin => dictionary[kanji]["pinyin"];
  String get tradChar => dictionary[kanji]["trad_char"];
  String get radicals => dictionary[kanji]["radicals"].split(",").join(', ');
  String get freq => dictionary[kanji]["freq"];
  String get percentile => dictionary[kanji]["percentile"];

  // These _could_ be NULL
  String? get english => dictionary[kanji]?["english"] == null ? null : dictionary[kanji]["english"].split(",").join(', ');
  String? get jyutping => dictionary[kanji]?["jyutping"] == null ? null : dictionary[kanji]["jyutping"];
  String? get zhuyin => dictionary[kanji]?["zhuyin"] == null ? null : dictionary[kanji]["zhuyin"];

  @override
  Widget build(BuildContext context) => Theme(
        data: kanjiLookupTheme,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('漢字情報'),
            toolbarHeight: 50,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.only(top: 25)),
                  // The kanji in question, displayed large
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: DottedBorder(
                      padding: const EdgeInsets.all(10.0),
                      color: const Color.fromARGB(255, 64, 64, 64),
                      strokeWidth: 1,
                      child: Center(
                        child: Text(
                          kanji,
                          style: const TextStyle(fontSize: 85),
                        ),
                      ),
                    ),
                  ),

                  if (english != null) ...[
                    InfoRow(leftText: '英文', rightText: english!),
                  ],

                  InfoRow(leftText: '拼音', rightText: pinyin),

                  if (zhuyin != null) ...[
                    InfoRow(leftText: '注音', rightText: zhuyin!),
                  ],
                  if (jyutping != null) ...[
                    InfoRow(leftText: '粵拼', rightText: jyutping!),
                  ],

                  InfoRow(leftText: '部首', rightText: radicals),
                  InfoRow(leftText: '繁體字', rightText: tradChar),
                  InfoRow(leftText: '频率', rightText: freq),
                  InfoRow(leftText: '累计\n频率', rightText: percentile),

                  const Padding(padding: EdgeInsets.only(top: 25)),
                ],
              ),
            ),
          ),
        ),
      );
}
