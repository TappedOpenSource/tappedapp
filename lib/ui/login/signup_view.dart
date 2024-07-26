import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/forms/apple_login_button.dart';
import 'package:intheloopapp/ui/forms/email_text_field.dart';
import 'package:intheloopapp/ui/forms/google_login_button.dart';
import 'package:intheloopapp/ui/forms/password_text_field.dart';
import 'package:intheloopapp/ui/login/components/confirm_signup_button.dart';
import 'package:intheloopapp/ui/login/login_cubit.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () async {
              final uri = Uri.parse('https://tapped.ai');
              await launchUrl(uri);
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => LoginCubit(
          auth: context.auth,
          nav: context.nav,
        ),
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            return Align(
              alignment: const Alignment(0, -1 / 3),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "let's get started",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'first, create an account to get you set up',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
                        labelText: 'confirm password',
                        onChanged: (input) => context
                            .read<LoginCubit>()
                            .updateConfirmPassword(input ?? ''),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Row(
                        children: [
                          Expanded(child: ConfirmSignUpButton()),
                        ],
                      ),
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
                        onPressed: () {
                          context
                              .read<LoginCubit>()
                              .signInWithGoogle()
                              .onError((error, stackTrace) {
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.red,
                                content: Text('could not sign in with Google'),
                              ),
                            );
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      if (Platform.isIOS)
                        AppleLoginButton(
                          onPressed: () {
                            context
                                .read<LoginCubit>()
                                .signInWithApple()
                                .onError((error, stackTrace) {
                              scaffoldMessenger.showSnackBar(
                                const SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.red,
                                  content: Text('could not sign in with Apple'),
                                ),
                              );
                            });
                            context.pop();
                          },
                        )
                      else
                        const SizedBox.shrink(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            child: const Text(
                              'privacy policy',
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
                              'terms of service',
                              style: TextStyle(
                                color: tappedAccent,
                              ),
                            ),
                            onPressed: () => launchUrl(
                              Uri(
                                scheme: 'https',
                                path:
                                    'www.apple.com/legal/internet-services/itunes/dev/stdeula/',
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
