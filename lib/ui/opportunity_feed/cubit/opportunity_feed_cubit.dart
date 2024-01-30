import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/domains/opportunity_bloc/opportunity_bloc.dart';
import 'package:intheloopapp/utils/app_logger.dart';

part 'opportunity_feed_state.dart';

class OpportunityFeedCubit extends Cubit<OpportunityFeedState> {
  OpportunityFeedCubit({
    required this.database,
    required this.opBloc,
    required this.currentUserId,
  }) : super(const OpportunityFeedState());

  final DatabaseRepository database;
  final OpportunityBloc opBloc;
  final String currentUserId;

  Future<void> initOpportunities() async {
    opBloc.add(const InitQuotaListener());
    emit(
      state.copyWith(
        loading: true,
      ),
    );
    final opportunities = await database.getOpportunityFeedByUserId(
      currentUserId,
    );

    emit(
      state.copyWith(
        curOp: 0,
        opportunities: opportunities..shuffle(),
        loading: false,
      ),
    );

    if (state.opportunities.isEmpty) {
      await analytics.logEvent(name: 'opportunities_exhausted');
    }
  }

  Future<void> fetchMoreOpportunities() async {
    try {
      final opportunities = await database.getOpportunityFeedByUserId(
        currentUserId,
        lastOpportunityId: state.opportunities.lastOrNull?.id,
      );
      emit(
        state.copyWith(
          opportunities: opportunities..shuffle(),
        ),
      );
    } catch (e, s) {
      logger.error(
        'Error fetching more opportunities',
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> nextOpportunity() async {
    emit(
      state.copyWith(
        curOp: state.curOp + 1,
      ),
    );

    if (state.curOp >= state.opportunities.length - 1) {
      await fetchMoreOpportunities();
    }

    if (state.opportunities.isEmpty ||
        state.curOp >= state.opportunities.length) {
      await analytics.logEvent(name: 'opportunities_exhausted');
    }
  }

  Future<void> dismissOpportunity() async {
    try {
      final curOpportunity = state.opportunities[state.curOp];

      // apply for opportunity just so it doesn't show up again
      opBloc.add(
        ApplyForOpportunity(
          opportunity: curOpportunity,
          userComment: '',
        ),
      );

      await nextOpportunity();
      await Future<void>.delayed(const Duration(milliseconds: 500));
    } catch (e, s) {
      logger.error(
        'Error dismissing opportunity',
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> likeOpportunity() async {
    // like animation
    emit(
      state.copyWith(showApplyAnimation: true),
    );

    try {
      // remove first from list
      final curOpportunity = state.opportunities[state.curOp];

      final opQuota = opBloc.state.opQuota;
      if (opQuota > 0) {
        await nextOpportunity();
        await Future<void>.delayed(const Duration(milliseconds: 1500));
      }
    } catch (e, s) {
      logger.error(
        'Error liking opportunity',
        error: e,
        stackTrace: s,
      );
    } finally {
      emit(state.copyWith(showApplyAnimation: false));
    }
  }

  Future<void> dislikeOpportunity() async {
    // disappear animation
    emit(
      state.copyWith(loading: true),
    );

    try {
      // remove first from list
      await nextOpportunity();
      await Future<void>.delayed(const Duration(milliseconds: 500));
    } catch (e, s) {
      logger.error(
        'Error disliking opportunity',
        error: e,
        stackTrace: s,
      );
    } finally {
      emit(state.copyWith(loading: false));
    }
  }
}
