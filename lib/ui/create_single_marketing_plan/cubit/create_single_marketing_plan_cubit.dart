import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/data/ai_repository.dart';
import 'package:intheloopapp/domains/models/marketing_plan.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/utils/app_logger.dart';

part 'create_single_marketing_plan_state.dart';

class CreateSingleMarketingPlanCubit
    extends Cubit<CreateSingleMarketingPlanState> {
  CreateSingleMarketingPlanCubit({
    required this.userId,
    required this.ai,
  }) : super(
          const CreateSingleMarketingPlanState(),
        );

  final String userId;
  final AIRepository ai;

  void updateName(String name) {
    emit(state.copyWith(name: Some(name)));
  }

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

  Future<void> submit() async {
    emit(state.copyWith(loading: true));

    try {
      final marketingPlan = await ai.createSingleMarketingPlan(
        name: state.name.unwrap,
        aesthetic: state.aesthetic.unwrap,
        targetAudience: state.targetAudience.unwrap,
        releaseTimeline: state.releaseTimeline.unwrap,
        moreToCome: state.moreToCome.unwrap,
        userId: userId,
      );

      emit(
        state.copyWith(
          marketingPlan: Some(marketingPlan),
        ),
      );
    } catch (e, s) {
      logger.error(
        'Error creating single marketing plan',
        error: e,
        stackTrace: s,
      );
    } finally {
      emit(
        state.copyWith(
          loading: false,
        ),
      );
    }
  }
}
