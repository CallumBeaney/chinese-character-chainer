// ignore_for_file: prefer_null_aware_operators

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:rensou_flutter/buttons.dart';
import 'package:rensou_flutter/locator.dart';
import 'package:rensou_flutter/ui/theme_data.dart';

class KanjiInfoView extends StatelessWidget {
  const KanjiInfoView({Key? key, required this.kanji})
      : super(
          key: key,
        );

  final String kanji;

  get dictionary => locator<Dictionary>();

  // These will _never_ be NULL
  String get readings => dictionary[kanji]!["kanji_readings"]!.split(",").join(', ');
  String get english => dictionary[kanji]!["english"]!.split(",").join(', ');
  String get radicals => dictionary[kanji]!["radicals"]!.split(",").join(', ');
  String get strokes => dictionary[kanji]!["strokes"]!.toString();

  // Heisig _could_ be NULL
  String? get heisigInd => dictionary[kanji]?["heisig_ind"] == null ? null : dictionary[kanji]["heisig_ind"];
  String? get heisigWord => dictionary[kanji]?["heisig_word"] == null ? null : dictionary[kanji]["heisig_word"];
  String? get heisig => heisigInd == null || heisigWord == null ? null : "#$heisigInd - \"$heisigWord\"";

  // Frequency data _could_ be NULL
  String? get newsFreq => dictionary[kanji]?["freq_news"] == null ? null : dictionary[kanji]["heisig_ind"];
  String? get wikiFreq => dictionary[kanji]?["freq_news"] == null ? null : dictionary[kanji]["heisig_ind"];

  // Onyomi kanji & readings _could_ be NULL
  List<String>? get onyomiKanji => dictionary[kanji]?["on_kanji"] == null ? null : dictionary[kanji]?["on_kanji"].split(",");
  List<String>? get onyomiKana => dictionary[kanji]?["on_kana"] == null ? null : dictionary[kanji]?["on_kana"].split(",");

  List<String>? get kunyomiKanji => dictionary[kanji]?["kun_kanji"] == null ? null : dictionary[kanji]?["kun_kanji"].split(",");
  List<String>? get kunyomiKana => dictionary[kanji]?["kun_kana"] == null ? null : dictionary[kanji]?["kun_kana"].split(",");

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

                  InfoRow(leftText: '発音', rightText: readings),
                  InfoRow(leftText: '英語', rightText: english),
                  InfoRow(leftText: '部首', rightText: radicals),
                  InfoRow(leftText: '字画', rightText: strokes),

                  if (newsFreq != null) ...[
                    InfoRow(leftText: '頻度', rightText: "$newsFreq 百分位数"),
                  ],
                  if (wikiFreq != null) ...[
                    InfoRow(leftText: 'ウィキ', rightText: "$wikiFreq 回出現する"),
                  ],

                  if (heisig != null) ...[
                    InfoRow(leftText: 'RTK', rightText: heisig!),
                  ],

                  if (onyomiKanji != null && onyomiKana != null) ...[
                    RubyRow(
                      leftText: '音読み',
                      rightText: onyomiKanji!,
                      ruby: onyomiKana!,
                    ),
                  ],

                  if (kunyomiKanji != null && kunyomiKana != null) ...[
                    RubyRow(
                      leftText: '訓読み',
                      rightText: kunyomiKanji!,
                      ruby: kunyomiKana!,
                    ),
                  ],

                  // if ()
                ],
              ),
            ),
          ),
        ),
      );
}
