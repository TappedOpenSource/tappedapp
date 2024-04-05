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
    try {
      final uid = await auth.signInWithCredentials(
        state.email,
        state.password,
      );
      emit(
        state.copyWith(status: FormzSubmissionStatus.success),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUpWithCredentials() async {
    if (state.password != state.confirmPassword) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
        ),
      );
      throw Exception('Passwords do not match');
    }
    try {
      final uid = await auth.signUpWithCredentials(
        state.email,
        state.password,
      );

      if (uid.isNone()) {
        throw Exception('Failed to create user');
      }
    } catch (e) {
      rethrow;
    }
    emit(
      state.copyWith(status: FormzSubmissionStatus.success),
    );
    nav.pop();
  }

  Future<void> signInWithApple() async {
    emit(
      state.copyWith(status: FormzSubmissionStatus.inProgress),
    );
    try {
      final _ = await auth.signInWithApple();
      emit(
        state.copyWith(status: FormzSubmissionStatus.success),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    emit(
      state.copyWith(status: FormzSubmissionStatus.inProgress),
    );
    try {
      await auth.signInWithGoogle();
      emit(
        state.copyWith(status: FormzSubmissionStatus.success),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendResetPasswordLink() async {
    await auth.recoverPassword(email: state.email);
  }
}
