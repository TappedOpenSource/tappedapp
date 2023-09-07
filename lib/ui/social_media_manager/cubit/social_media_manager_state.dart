part of 'social_media_manager_cubit.dart';

class SocialMediaManagerState extends Equatable {
  const SocialMediaManagerState({
    required this.credits,
    required this.postIdea,
  });

  final String postIdea;
  final int credits;

  @override
  List<Object> get props => [
        credits,
        postIdea,
      ];

  SocialMediaManagerState copyWith({
    int? credits,
    String? postIdea,
  }) {
    return SocialMediaManagerState(
      credits: credits ?? this.credits,
      postIdea: postIdea ?? this.postIdea,
    );
  }
}
