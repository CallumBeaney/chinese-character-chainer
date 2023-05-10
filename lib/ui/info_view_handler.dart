import 'package:flutter/material.dart';
import 'package:character_chainer/model/model.dart';
import 'package:character_chainer/ui/info_view_jp.dart';
import 'package:character_chainer/ui/info_view_zh.dart';

// This class checks the current state of language config (see: model/language_config.dart) and opens a Chinese character information screen corresponding with the dictionary in use.
// Because the Traditional & Simplified dictionaries both have the same structure, it is only necessary to define two info-views.

class InfoView extends StatelessWidget {
  final LanguageConfig config;
  final String character;

  const InfoView({
    super.key,
    required this.config,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    if (config.infoViewType == InfoViewType.kanji) {
      return KanjiInfoView(kanji: character, config: config);
    } else if (config.infoViewType == InfoViewType.hanzi) {
      return HanziInfoView(hanzi: character, config: config);
    }
    throw UnimplementedError();
  }
}
