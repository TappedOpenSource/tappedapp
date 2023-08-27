part of 'generation_bloc.dart';

class GenerationState extends Equatable {
  const GenerationState({
    this.selectedAesthetic = const None(),
    this.imageUrls = const None(),
    this.loading = false,
  });

  final Option<String> selectedAesthetic;
  final Option<List<String>> imageUrls;
  final bool loading;

  @override
  List<Object> get props => [
        selectedAesthetic,
        imageUrls,
        loading,
      ];

  GenerationState copyWith({
    Option<String>? selectedAesthetic,
    Option<List<String>>? imageUrls,
    bool? loading,
  }) {
    return GenerationState(
      selectedAesthetic: selectedAesthetic ?? this.selectedAesthetic,
      imageUrls: imageUrls ?? this.imageUrls,
      loading: loading ?? this.loading,
    );
  }
}
