import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/utils/app_logger.dart';

part 'loop_feed_state.dart';

class LoopFeedCubit extends Cubit<LoopFeedState> {
  LoopFeedCubit({
    required this.userId,
    required this.sourceFunction,
    required this.sourceStream,
  }) : super(const LoopFeedState());

  final String userId;
  final Future<List<Loop>> Function(
    String userId, {
    int limit,
    String? lastLoopId,
    bool ignoreCache,
  }) sourceFunction;
  final Stream<Loop> Function(
    String userId, {
    int limit,
    bool ignoreCache,
  }) sourceStream;
  StreamSubscription<Loop>? loopListener;

  Future<void> initLoops({bool clearLoops = true}) async {
    final trace = logger.createTrace('init loops');
    await trace.start();
    try {
      await loopListener?.cancel();
      if (clearLoops) {
        emit(
          state.copyWith(
            status: LoopFeedStatus.initial,
            loops: [],
            hasReachedMax: false,
          ),
        );
      }

      final loopsAvailable = await sourceFunction(
        userId,
        limit: 1,
      );
      if (loopsAvailable.isEmpty) {
        emit(state.copyWith(status: LoopFeedStatus.success));
      }

      loopListener = sourceStream(
        userId,
        ignoreCache: true,
      ).listen((Loop event) {
        logger.debug('loop { ${event.id} : ${event.title} }');
        try {
          emit(
            state.copyWith(
              status: LoopFeedStatus.success,
              loops: List.of(state.loops)
                ..add(event)
                ..sort(
                  (a, b) => b.timestamp.compareTo(a.timestamp),
                ),
            ),
          );
        } catch (e, s) {
          logger.error(
            'cannot add loop to loop feed',
            error: e,
            stackTrace: s,
          );
        }
      });
    } catch (e, s) {
      logger.error(
        'cannot init loops on loop feed',
        error: e,
        stackTrace: s,
      );
    } finally {
      await trace.stop();
    }
  }

  Future<void> fetchMoreLoops() async {
    if (state.hasReachedMax) return;
    final trace = logger.createTrace('fetch more loops');
    await trace.start();

    try {
      if (state.status == LoopFeedStatus.initial) {
        await initLoops();
      }

      final loops = await sourceFunction(
        userId,
        lastLoopId: state.loops.last.id,
      );
      loops.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: LoopFeedStatus.success,
                loops: List.of(state.loops)
                  ..addAll(loops)
                  ..sort(
                    (a, b) => b.timestamp.compareTo(a.timestamp),
                  ),
                hasReachedMax: false,
              ),
            );
    } catch (e, s) {
      logger.error(
        'cannot fetch more loops on loop feed',
        error: e,
        stackTrace: s,
      );
      emit(state.copyWith(status: LoopFeedStatus.failure));
    } finally {
      await trace.stop();
    }
  }

  @override
  Future<void> close() async {
    await loopListener?.cancel();
    await super.close();
  }
}
