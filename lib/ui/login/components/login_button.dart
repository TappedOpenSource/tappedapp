import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/login/login_cubit.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = context.nav;
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return CupertinoButton.filled(
          onPressed: () async {
            try {
              await context.read<LoginCubit>().signInWithCredentials();
              nav.pop();
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red,
                  content: Text(e.toString()),
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(15),
          child: const Text(
            'login',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      },
    );
  }
}
