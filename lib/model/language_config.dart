import 'model.dart';

class LanguageConfig {
  final String code;
  final Dictionary dictionary;
  final Placeholders placeholders;
  final InfoViewType infoViewType;

  const LanguageConfig({
    required this.code,
    required this.dictionary,
    required this.placeholders,
    required this.infoViewType,
  });

  static const LanguageConfig jp = LanguageConfig(
    code: 'ja',
    dictionary: Dictionaries.jp,
    placeholders: Placeholders.jp,
    infoViewType: InfoViewType.kanji,
  );

  static const LanguageConfig zhSimp = LanguageConfig(
    code: 'zh-Hani-CN',
    dictionary: Dictionaries.zhSimp,
    placeholders: Placeholders.zhSimp,
    infoViewType: InfoViewType.hanzi,
  );

  static const LanguageConfig zhTrad = LanguageConfig(
    code: 'zh-Hani-TW',
    dictionary: Dictionaries.zhTrad,
    placeholders: Placeholders.zhTrad,
    infoViewType: InfoViewType.hanzi,
  );
}
