import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/login/login_cubit.dart';

class ConfirmSignUpButton extends StatelessWidget {
  const ConfirmSignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return CupertinoButton.filled(
          borderRadius: BorderRadius.circular(15),
          onPressed: () async {
            try {
              await context.read<LoginCubit>().signUpWithCredentials();
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(e.toString()),
                ),
              );
            }
          },
          child: const Text(
            'Sign Up',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      },
    );
  }
}
