import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/utils/app_logger.dart';

part 'opportunity_feed_state.dart';

class OpportunityFeedCubit extends Cubit<OpportunityFeedState> {
  OpportunityFeedCubit({
    required this.database,
    required this.currentUserId,
  }) : super(const OpportunityFeedState());

  final DatabaseRepository database;
  final String currentUserId;

  Future<void> initOpportunities() async {
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
        opportunities: opportunities,
        loading: false,
      ),
    );
  }

  Future<void> fetchMoreOpportunities() async {
    emit(
      state.copyWith(
        loading: true,
      ),
    );
    try {
      final opportunities = await database.getOpportunityFeedByUserId(
        currentUserId,
        lastOpportunityId: state.opportunities.lastOrNull?.id,
      );
      emit(
        state.copyWith(
          opportunities: opportunities,
        ),
      );
    } catch (e, s) {
      logger.error(
        'Error fetching more opportunities',
        error: e,
        stackTrace: s,
      );
    } finally {
      emit(state.copyWith(loading: false));
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
  }

  Future<void> likeOpportunity() async {
    // like animation
    emit(
      state.copyWith(showApplyAnimation: true),
    );

    try {
      // remove first from list
      final curOpportunity = state.opportunities[state.curOp];
      await nextOpportunity();

      await database.applyForOpportunity(
        opportunity: curOpportunity,
        userId: currentUserId,
        userComment: '',
      );

      sleep(const Duration(milliseconds: 1500));
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
      final curOpportunity = state.opportunities[state.curOp];

      // remove first from list
      await nextOpportunity();

      await database.dislikeOpportunity(
        opportunity: curOpportunity,
        userId: currentUserId,
      );
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
