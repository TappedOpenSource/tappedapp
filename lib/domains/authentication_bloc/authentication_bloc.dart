import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/utils/app_logger.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(Uninitialized()) {
    _userSubscription = authRepository.authStateChanges.listen(_onUserChanged);

    on<AppStarted>((event, emit) async {
      try {
        final isSignedIn = await _authRepository.isSignedIn();
        if (isSignedIn) {
          final user = await _authRepository.getAuthUser();
          logger.setUserIdentifier(user!.uid);
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated());
        }
      } catch (_) {
        emit(Unauthenticated());
      }
    });
    on<LoggedIn>((event, emit) {
      try {
        emit(Authenticated(event.user));
      } catch (e, s) {
        logger.error(
          'error logging in',
          error: e,
          stackTrace: s,
        );
        emit(Unauthenticated());
      }
    });
    on<LoggedOut>((event, emit) {
      emit(Unauthenticated());
      _authRepository.logout();
    });
  }

  final AuthRepository _authRepository;
  late final StreamSubscription<User?> _userSubscription;

  void _onUserChanged(User? user) {
    logger.info('user changed: $user');

    if (user == null || state is Authenticated) {
      return;
    }

    add(LoggedIn(user: user));
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
