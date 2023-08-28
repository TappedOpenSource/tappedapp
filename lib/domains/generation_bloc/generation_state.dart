part of 'generation_bloc.dart';

class GenerationState extends Equatable {
  const GenerationState({
    this.selectedPrompt = const None(),
    this.imageUrls = const None(),
    this.loading = false,
  });

  final Option<String> selectedPrompt;
  final Option<List<String>> imageUrls;
  final bool loading;

  @override
  List<Object> get props => [
        selectedPrompt,
        imageUrls,
        loading,
      ];

  GenerationState copyWith({
    Option<String>? selectedPrompt,
    Option<List<String>>? imageUrls,
    bool? loading,
  }) {
    return GenerationState(
      selectedPrompt: selectedPrompt ?? this.selectedPrompt,
      imageUrls: imageUrls ?? this.imageUrls,
      loading: loading ?? this.loading,
    );
  }
}
