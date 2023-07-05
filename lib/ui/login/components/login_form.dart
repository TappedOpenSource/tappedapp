import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/ui/forms/apple_login_button.dart';
import 'package:intheloopapp/ui/forms/google_login_button.dart';
import 'package:intheloopapp/ui/loading/logo_wave.dart';
import 'package:intheloopapp/ui/login/components/traditional_login.dart';
import 'package:intheloopapp/ui/login/login_cubit.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text('Authentication Failure'),
              ),
            );
          context.read<LoginCubit>().resetStatus();
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LogoWave(),
                const SizedBox(height: 50),
                const TraditionalLogin(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GoogleLoginButton(
                      onPressed: () async {
                        try {
                          await context.read<LoginCubit>().signInWithGoogle();
                        } catch (e) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text('Authentication Failure'),
                              ),
                            );
                        }
                      },
                    ),
                    const SizedBox(width: 20),
                    if (Platform.isIOS)
                      AppleLoginButton(
                        onPressed: () async {
                          try {
                            await context.read<LoginCubit>().signInWithApple();
                          } catch (e) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.redAccent,
                                  content: Text('Authentication Failure'),
                                ),
                              );
                          }
                        },
                      )
                    else
                      const SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
