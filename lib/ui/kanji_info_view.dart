import 'package:flutter/material.dart';
import 'package:rensou_flutter/buttons.dart';
import 'package:rensou_flutter/dictionary.dart';
import 'package:rensou_flutter/locator.dart';
import 'package:rensou_flutter/ui/theme_data.dart';

import '../locator.dart';

// ignore: camel_case_types
class kanjiInfoView extends StatelessWidget {
  const kanjiInfoView({Key? key, required this.kanji})
      : super(
          key: key,
        );

// TODO: ask Alex why does putting tostring here with the dictionary's formatting add spaces but if not there doesnt.
// TODO: implement furigana: https://pub.dev/packages/ruby_text
  final String kanji;

  get dictionary => locator<Dictionary>();
  // These will _never_ be NULL
  String get readings => dictionary[kanji]!["kanji_readings"]!.split(",").join(', ');
  String get english => dictionary[kanji]!["english"]!.split(",").join(', ');
  String get radicals => dictionary[kanji]!["radicals"]!.split(",").join(', ');
  String get strokes => dictionary[kanji]!["strokes"]!.toString();
  String get wikiFrequency => dictionary[kanji]!["freq_wiki"]!.toString();

  // Heisig _could_ be NULL
  String? get heisigInd => dictionary[kanji]?["heisig_ind"] == null ? null : dictionary[kanji]["heisig_ind"];
  String? get heisigWord => dictionary[kanji]?["heisig_word"] == null ? null : dictionary[kanji]["heisig_word"];
  String get heisig => heisigInd == null || heisigWord == null ? "No data available" : "#$heisigInd: \"$heisigWord\"";

  @override
  Widget build(BuildContext context) => Theme(
        data: kanjiLookupTheme,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('漢字情報'),
            toolbarHeight: 50,
          ),
          body: SafeArea(
            child: Column(
              children: [
                // ignore: prefer_const_constructors
                Padding(padding: EdgeInsets.symmetric(vertical: 65.0)),
                // The kanji in question, displayed large
                Center(
                  child: Text(
                    kanji,
                    style: const TextStyle(fontSize: 85),
                  ),
                ),

                infoRow(leftText: '発音', rightText: readings),
                infoRow(leftText: '英語', rightText: english),
                infoRow(leftText: '部首', rightText: radicals),
                infoRow(leftText: '字画', rightText: strokes),
                infoRow(leftText: 'Heisig', rightText: heisig),
                // if ()
              ],
            ),
          ),
        ),
      );
}
