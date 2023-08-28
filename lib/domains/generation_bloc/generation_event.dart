part of 'generation_bloc.dart';

sealed class GenerationEvent extends Equatable {
  const GenerationEvent();

  @override
  List<Object> get props => [];
}

class SelectPrompt extends GenerationEvent {
  const SelectPrompt({
    required this.prompt,
  });

  final String prompt;

  @override
  List<Object> get props => [prompt];
}

class GenerateAvatar extends GenerationEvent {
  const GenerateAvatar({
    required this.prompt,
  });

  final String prompt;

  @override
  List<Object> get props => [prompt];
}

class ResetGeneration extends GenerationEvent {
  const ResetGeneration();
}
