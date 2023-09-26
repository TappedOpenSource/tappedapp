part of 'create_single_marketing_plan_cubit.dart';

class CreateSingleMarketingPlanState extends Equatable {
  const CreateSingleMarketingPlanState({
    this.aesthetic = const None(),
    this.targetAudience = const None(),
    this.moreToCome = const None(),
    this.releaseTimeline = const None(),
    this.loading = false,
    this.marketingPlan = const None(),
  });

  final bool loading;
  final Option<MarketingPlan> marketingPlan;
  final Option<String> aesthetic;
  final Option<String> targetAudience;
  final Option<String> moreToCome;
  final Option<String> releaseTimeline;

  @override
  List<Object> get props => [
        marketingPlan,
        loading,
        aesthetic,
        targetAudience,
        moreToCome,
        releaseTimeline,
      ];

  CreateSingleMarketingPlanState copyWith({
    Option<MarketingPlan>? marketingPlan,
    bool? loading,
    Option<String>? aesthetic,
    Option<String>? targetAudience,
    Option<String>? moreToCome,
    Option<String>? releaseTimeline,
  }) {
    return CreateSingleMarketingPlanState(
      marketingPlan: marketingPlan ?? this.marketingPlan,
      loading: loading ?? this.loading,
      aesthetic: aesthetic ?? this.aesthetic,
      targetAudience: targetAudience ?? this.targetAudience,
      moreToCome: moreToCome ?? this.moreToCome,
      releaseTimeline: releaseTimeline ?? this.releaseTimeline,
    );
  }
}
