part of 'recognition_manager_cubit.dart';

class RecognitionManagerState {
  final List<String> candidates;
  final List<String> results;

  String? get comparator => results.isEmpty ? null : results.last;

  const RecognitionManagerState({
    this.candidates = const [],
    this.results = const [],
  });

  static const initial = RecognitionManagerState();

  RecognitionManagerState copyWith({
    List<String>? candidates,
    List<String>? results,
  }) =>
      RecognitionManagerState(
        candidates: candidates ?? this.candidates,
        results: results ?? this.results,
      );

  RecognitionManagerState addResult(String result) =>
      copyWith(results: [...results, result], candidates: []);
}
