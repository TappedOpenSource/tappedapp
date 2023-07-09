import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/forms/apple_login_button.dart';
import 'package:intheloopapp/ui/forms/email_text_field.dart';
import 'package:intheloopapp/ui/forms/google_login_button.dart';
import 'package:intheloopapp/ui/forms/password_text_field.dart';
import 'package:intheloopapp/ui/loading/logo_wave.dart';
import 'package:intheloopapp/ui/login/components/confirm_signup_button.dart';
import 'package:intheloopapp/ui/login/login_cubit.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocProvider(
        create: (context) => LoginCubit(
          authRepository: context.read<AuthRepository>(),
          navigationBloc: context.read<NavigationBloc>(),
        ),
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return Align(
              alignment: const Alignment(0, -1 / 3),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const LogoWave(),
                      const SizedBox(height: 50),
                      EmailTextField(
                        onChanged: (input) =>
                            context.read<LoginCubit>().updateEmail(input ?? ''),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      PasswordTextField(
                        onChanged: (input) => context
                            .read<LoginCubit>()
                            .updatePassword(input ?? ''),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      PasswordTextField(
                        labelText: 'Confirm Password',
                        onChanged: (input) => context
                            .read<LoginCubit>()
                            .updateConfirmPassword(input ?? ''),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const ConfirmSignUpButton(),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              height: 0,
                              thickness: 0.5,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'or',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Divider(
                              height: 0,
                              thickness: 0.5,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      GoogleLoginButton(
                        onPressed: () async {
                          try {
                            await context.read<LoginCubit>().signInWithGoogle();
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
                      ),
                      const SizedBox(height: 20),
                      if (Platform.isIOS)
                        AppleLoginButton(
                          onPressed: () async {
                            try {
                              await context
                                  .read<LoginCubit>()
                                  .signInWithApple();
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
                        )
                      else
                        const SizedBox.shrink(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            child: const Text(
                              'Privacy Policy',
                              style: TextStyle(
                                color: tappedAccent,
                              ),
                            ),
                            onPressed: () => launchUrl(
                              Uri(
                                scheme: 'https',
                                path: 'tapped.ai/privacy',
                              ),
                            ),
                          ),
                          TextButton(
                            child: const Text(
                              'Terms of Service',
                              style: TextStyle(
                                color: tappedAccent,
                              ),
                            ),
                            onPressed: () => launchUrl(
                              Uri(
                                scheme: 'https',
                                path: 'tapped.ai/terms',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
