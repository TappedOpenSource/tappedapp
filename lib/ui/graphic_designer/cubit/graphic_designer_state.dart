part of 'graphic_designer_cubit.dart';

class GraphicDesignerState extends Equatable {
  const GraphicDesignerState({
    required this.claim,
    this.avatars = const [],
    this.hasImageModel = false,
  });

  final String claim;
  final List<Avatar> avatars;
  final bool hasImageModel;

  @override
  List<Object?> get props => [
        claim,
        avatars,
        hasImageModel,
      ];

  GraphicDesignerState copyWith({
    String? claim,
    List<Avatar>? avatars,
    bool? hasImageModel,
  }) {
    return GraphicDesignerState(
      claim: claim ?? this.claim,
      avatars: avatars ?? this.avatars,
      hasImageModel: hasImageModel ?? this.hasImageModel,
    );
  }
}
