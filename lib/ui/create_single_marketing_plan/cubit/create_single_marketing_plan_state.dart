part of 'create_single_marketing_plan_cubit.dart';

class CreateSingleMarketingPlanState extends Equatable {
  const CreateSingleMarketingPlanState({
    this.aesthetic = const None(),
    this.targetAudience = const None(),
    this.moreToCome = const None(),
    this.releaseTimeline = const None(),
    this.isSubmitted = false,
  });

  final bool isSubmitted;
  final Option<String> aesthetic;
  final Option<String> targetAudience;
  final Option<String> moreToCome;
  final Option<String> releaseTimeline;

  @override
  List<Object> get props => [
        isSubmitted,
        aesthetic,
        targetAudience,
        moreToCome,
        releaseTimeline,
      ];

  CreateSingleMarketingPlanState copyWith({
    bool? isSubmitted,
    Option<String>? aesthetic,
    Option<String>? targetAudience,
    Option<String>? moreToCome,
    Option<String>? releaseTimeline,
  }) {
    return CreateSingleMarketingPlanState(
      isSubmitted: isSubmitted ?? this.isSubmitted,
      aesthetic: aesthetic ?? this.aesthetic,
      targetAudience: targetAudience ?? this.targetAudience,
      moreToCome: moreToCome ?? this.moreToCome,
      releaseTimeline: releaseTimeline ?? this.releaseTimeline,
    );
  }
}
