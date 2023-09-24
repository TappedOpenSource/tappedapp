import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/domains/models/option.dart';

part 'create_single_marketing_plan_state.dart';

class CreateSingleMarketingPlanCubit
    extends Cubit<CreateSingleMarketingPlanState> {
  CreateSingleMarketingPlanCubit()
      : super(
          const CreateSingleMarketingPlanState(),
        );

  void updateAesthetic(String aesthetic) {
    emit(state.copyWith(aesthetic: Some(aesthetic)));
  }

  void updateTargetAudience(String targetAudience) {
    emit(state.copyWith(targetAudience: Some(targetAudience)));
  }

  void updateMoreToCome(String moreToCome) {
    emit(state.copyWith(moreToCome: Some(moreToCome)));
  }

  void updateReleaseTimeline(String releaseTimeline) {
    emit(state.copyWith(releaseTimeline: Some(releaseTimeline)));
  }

  void submit() {
    emit(state.copyWith(isSubmitted: true));
  }
}
