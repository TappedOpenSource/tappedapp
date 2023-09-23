part of 'create_single_marketing_plan_cubit.dart';

class CreateSingleMarketingPlanState extends Equatable {
  const CreateSingleMarketingPlanState({
    this.isSubmitted = false,
  });

  final bool isSubmitted;

  @override
  List<Object> get props => [];

  CreateSingleMarketingPlanState copyWith({
    bool? isSubmitted,
  }) {
    return CreateSingleMarketingPlanState(
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }
}
