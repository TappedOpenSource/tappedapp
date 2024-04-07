import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/login/login_cubit.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class ConfirmSignUpButton extends StatelessWidget {
  const ConfirmSignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = context.nav;
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        return CupertinoButton.filled(
          borderRadius: BorderRadius.circular(15),
          onPressed: () {
            context
                .read<LoginCubit>()
                .signUpWithCredentials()
                .onError((error, stackTrace) {
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red,
                  content: Text(error.toString()),
                ),
              );
            });
            context.pop();
          },
          child: const Text(
            'sign up',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
