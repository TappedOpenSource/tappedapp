import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_single_marketing_plan_state.dart';

class CreateSingleMarketingPlanCubit
    extends Cubit<CreateSingleMarketingPlanState> {
  CreateSingleMarketingPlanCubit()
      : super(
          const CreateSingleMarketingPlanState(),
        );

  void updateAethetic(String aesthetic) {}
  void updateTargetAudience(String targetAudience) {}
  void updateMoreToCome(String moreToCome) {}
  void updateReleaseTimeline(String releaseTimeline) {}

  void submit() {
    emit(state.copyWith(isSubmitted: true));
  }
}
