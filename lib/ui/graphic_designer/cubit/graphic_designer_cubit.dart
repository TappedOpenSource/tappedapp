import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/avatar.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/utils/app_logger.dart';

part 'graphic_designer_state.dart';

class GraphicDesignerCubit extends Cubit<GraphicDesignerState> {
  GraphicDesignerCubit({
    required this.database,
    required this.currentUser,
    required this.claim,
  }) : super(
          GraphicDesignerState(
            claim: claim,
          ),
        );

  final String claim;
  final DatabaseRepository database;
  final UserModel currentUser;
  StreamSubscription<Avatar>? avatarListener;

  Future<void> getAvatars() async {
    final avatars = await database.getUserAvatars(currentUser.id);
    emit(state.copyWith(avatars: avatars));
  }

  Future<void> initAvatars({bool clearAvatars = true}) async {
    final trace = logger.createTrace('init avatars');
    await trace.start();
    try {
      await avatarListener?.cancel();
      if (clearAvatars) {
        emit(
          state.copyWith(
            avatars: [],
          ),
        );
      }

      avatarListener = database
          .userAvatarsObserver(
        currentUser.id,
      )
          .listen((Avatar avatar) {
        logger.debug('avatar { ${avatar.id} }');
        try {
          emit(
            state.copyWith(
              avatars: List.of(state.avatars)
                ..add(avatar)
                ..sort(
                  (a, b) => b.timestamp.compareTo(a.timestamp),
                ),
            ),
          );
        } catch (e, s) {
          logger.error(
            'cannot add avatar',
            error: e,
            stackTrace: s,
          );
        }
      });
    } catch (e, s) {
      logger.error(
        'cannot init avatar',
        error: e,
        stackTrace: s,
      );
    } finally {
      await trace.stop();
    }
  }
}
