part of 'graphic_designer_cubit.dart';

class GraphicDesignerState extends Equatable {
  const GraphicDesignerState({
    required this.claim,
    this.avatars = const [],
  });

  final String claim;
  final List<Avatar> avatars;

  @override
  List<Object?> get props => [
        claim,
        avatars,
      ];

  GraphicDesignerState copyWith({
    String? claim,
    List<Avatar>? avatars,
  }) {
    return GraphicDesignerState(
      claim: claim ?? this.claim,
      avatars: avatars ?? this.avatars,
    );
  }
}
