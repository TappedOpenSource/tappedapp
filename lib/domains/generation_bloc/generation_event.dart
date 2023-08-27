part of 'generation_bloc.dart';

sealed class GenerationEvent extends Equatable {
  const GenerationEvent();

  @override
  List<Object> get props => [];
}

class SelectAesthetic extends GenerationEvent {
  const SelectAesthetic({
    required this.aesthetic,
  });

  final String aesthetic;

  @override
  List<Object> get props => [aesthetic];
}

class GenerateAvatar extends GenerationEvent {
  const GenerateAvatar({
    required this.aesthetic,
  });

  final String aesthetic;

  @override
  List<Object> get props => [aesthetic];
}

class ResetGeneration extends GenerationEvent {
  const ResetGeneration();
}
