import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/login/components/login_form.dart';
import 'package:intheloopapp/ui/login/login_cubit.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocProvider(
        create: (context) => LoginCubit(
          authRepository: context.auth,
          navigationBloc: context.read<NavigationBloc>(),
        ),
        child: const LoginForm(),
      ),
    );
  }
}
