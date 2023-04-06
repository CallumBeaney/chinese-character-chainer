part of 'language_manager_cubit.dart';

class LanguageManagerState {
  final String? language;
  final String? dictionary;

  const LanguageManagerState({
    this.language = "",
    this.dictionary = "",
  });

  static const initial = LanguageManagerState();

  LanguageManagerState copyWith({
    final String? language,
    final String? dictionary,
  }) =>
      LanguageManagerState(
        language: language ?? this.language,
        dictionary: dictionary ?? this.dictionary,
      );
}
