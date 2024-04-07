import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required this.auth,
    required this.nav,
  }) : super(const LoginState());
  final AuthRepository auth;
  final NavigationBloc nav;

  void resetStatus() => emit(
        state.copyWith(
          status: FormzSubmissionStatus.initial,
        ),
      );

  void updateEmail(String? input) => emit(
        state.copyWith(
          email: input,
        ),
      );
  void updatePassword(String? input) => emit(
        state.copyWith(
          password: input,
        ),
      );
  void updateConfirmPassword(String input) => emit(
        state.copyWith(
          confirmPassword: input,
        ),
      );

  Future<void> signInWithCredentials() async {
    emit(
      state.copyWith(status: FormzSubmissionStatus.inProgress),
    );

    try {
      final uid = await auth.signInWithCredentials(
        state.email,
        state.password,
      );

      if (uid.isNone()) {
        throw Exception('failed to create user');
      }

    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUpWithCredentials() async {
    if (state.password != state.confirmPassword) {
      throw Exception('passwords do not match');
    }

    try {
      final uid = await auth.signUpWithCredentials(
        state.email,
        state.password,
      );

      if (uid.isNone()) {
        throw Exception('failed to create user');
      }
    } catch (e) {
      rethrow;
    }
    nav.pop();
  }

  Future<void> signInWithApple() async {
    emit(
      state.copyWith(status: FormzSubmissionStatus.inProgress),
    );
    try {
      final uid = await auth.signInWithApple();

      if (uid.isNone()) {
        throw Exception('failed to create user');
      }

    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    emit(
      state.copyWith(status: FormzSubmissionStatus.inProgress),
    );
    try {
      final uid = await auth.signInWithGoogle();

      if (uid.isNone()) {
        throw Exception('failed to create user');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendResetPasswordLink() async {
    await auth.recoverPassword(email: state.email);
  }
}
