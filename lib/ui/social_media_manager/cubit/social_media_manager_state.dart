part of 'social_media_manager_cubit.dart';

class SocialMediaManagerState extends Equatable {
  const SocialMediaManagerState({
    required this.postIdea,
  });

  final String postIdea;

  @override
  List<Object> get props => [
        postIdea,
      ];

  SocialMediaManagerState copyWith({
    String? postIdea,
  }) {
    return SocialMediaManagerState(
      postIdea: postIdea ?? this.postIdea,
    );
  }
}
