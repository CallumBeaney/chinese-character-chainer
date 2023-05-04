class Placeholders {
  final List<String> charList;
  final List<String> recognition;
  const Placeholders({required this.charList, required this.recognition});

  static const Placeholders zhTrad = Placeholders(charList: [
    '這', '裡', '是', '您', '的', // comment here to prevent columnisation
    '漢', '字', '列', '表', '。',
    '按', '漢', '字', '可', '獲',
    '取', '有', '關', '它', '的',
    '信', '息', '。',
  ], recognition: [
    '請', '寫', '一', '個', '漢', '字' //
  ]);

  static const Placeholders zhSimp = Placeholders(charList: [
    '这', '里', '是', '您', '的', //
    '汉', '字', '列', '表', '。',
    '按', '汉', '字', '可', '获',
    '取', '有', '关', '它',
    '的', '信', '息', '。', // "This is your hanzi list. Press a hanzi button and info will pop up
  ], recognition: [
    '请', '写', '一', '个', '汉', '字' // "write a hanzi"
  ]);

  static const Placeholders jp = Placeholders(
    charList: [
      'こ', 'こ', 'は', 'あ', 'な', // "This is your kanji list..."
      'た', 'の', '漢', '字', '列',
      'で', 'す', '。', '漢', '字',
      'を', '押', 'せ', 'ば', '情',
      '報', 'が', '出', 'る', '。',
    ],
    recognition: ['漢', '字', 'を', '書', 'い', 'て'], // "Write a kanji"
  );
}
