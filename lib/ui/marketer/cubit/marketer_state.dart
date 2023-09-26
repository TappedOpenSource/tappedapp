part of 'marketer_cubit.dart';

class MarketerState extends Equatable {
  const MarketerState({
    this.marketingPlans = const [],
  });

  final List<MarketingPlan> marketingPlans;

  @override
  List<Object> get props => [marketingPlans];

  MarketerState copyWith({
    List<MarketingPlan>? marketingPlans,
  }) {
    return MarketerState(
      marketingPlans: marketingPlans ?? this.marketingPlans,
    );
  }
}
