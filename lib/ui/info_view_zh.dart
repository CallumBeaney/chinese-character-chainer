import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:character_chainer/buttons.dart';
import 'package:character_chainer/model/model.dart';
import 'package:character_chainer/ui/app_theme_data.dart';

class HanziInfoView extends StatelessWidget {
  final String hanzi;
  final LanguageConfig config;

  const HanziInfoView({
    super.key,
    required this.hanzi,
    required this.config,
  });

  Dictionary get dictionary => config.dictionary;

  // These will _never_ be NULL
  String get pinyin => dictionary[hanzi]!["pinyin"]!;
  String get radicals => dictionary[hanzi]!["radicals"]!.split(",").join(', ');
  String get freq => dictionary[hanzi]!["freq"]!;
  String get percentile => dictionary[hanzi]!["percentile"]!;

  // These _could_ be NULL
  String? get english => dictionary[hanzi]?["english"]?.split(",").join(', ');
  String? get jyutping => dictionary[hanzi]?["jyutping"];
  String? get zhuyin => dictionary[hanzi]?["zhuyin"];

  @override
  Widget build(BuildContext context) => Theme(
        data: infoViewTheme,
        child: Scaffold(
          appBar: AppBar(
            title: config.code == 'zh-Hani-CN' ? const Text('汉字资讯') : const Text('漢字資訊'),
            toolbarHeight: 50,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.only(top: 25)),
                  // The hanzi in question, displayed large
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: DottedBorder(
                      padding: const EdgeInsets.all(10.0),
                      color: const Color.fromARGB(255, 64, 64, 64),
                      strokeWidth: 1,
                      child: Center(
                        child: Text(
                          hanzi,
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

                  if (config.code == "zh-Hani-CN" && hanzi != (dictionary[hanzi]!["alt_char"]!)) ...[
                    InfoRow(leftText: '繁體字', rightText: dictionary[hanzi]!["alt_char"]!),
                  ],

                  if (config.code == "zh-Hani-TW" && hanzi != (dictionary[hanzi]!["alt_char"]!)) ...[
                    InfoRow(leftText: '簡體字', rightText: dictionary[hanzi]!["alt_char"]!),
                  ],

                  InfoRow(leftText: '部首', rightText: radicals),
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
