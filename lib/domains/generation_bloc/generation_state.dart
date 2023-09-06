part of 'generation_bloc.dart';

class GenerationState extends Equatable {
  const GenerationState({
    this.selectedPrompt = const None(),
    this.results = const None(),
    this.loading = false,
  });

  final Option<String> selectedPrompt;
  final Option<List<GenerationResult>> results;
  final bool loading;

  @override
  List<Object> get props => [
        selectedPrompt,
        results,
        loading,
      ];

  GenerationState copyWith({
    Option<String>? selectedPrompt,
    Option<List<GenerationResult>>? results,
    bool? loading,
  }) {
    return GenerationState(
      selectedPrompt: selectedPrompt ?? this.selectedPrompt,
      results: results ?? this.results,
      loading: loading ?? this.loading,
    );
  }
}

class GenerationResult {
  const GenerationResult({
    required this.inferenceId,
    required this.imageUrl,
    required this.prompt,
  });

  final String inferenceId;
  final String imageUrl;
  final String prompt;
}
