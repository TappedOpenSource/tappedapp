import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/forms/email_text_field.dart';
import 'package:intheloopapp/ui/login/login_cubit.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  bool linkSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Password Reset'),
      ),
      body: BlocProvider(
        create: (context) => LoginCubit(
          auth: context.auth,
          nav: context.nav,
        ),
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Align(
                child: linkSent
                    ? const Text('Password reset link send to your email')
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EmailTextField(
                            onChanged: context.read<LoginCubit>().updateEmail,
                          ),
                          const SizedBox(height: 30),
                          CupertinoButton.filled(
                            child: const Text('Send Reset Link'),
                            onPressed: () {
                              context
                                  .read<LoginCubit>()
                                  .sendResetPasswordLink();
                              setState(() {
                                linkSent = true;
                              });
                            },
                          ),
                        ],
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
