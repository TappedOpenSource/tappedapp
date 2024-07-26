import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/login/components/login_form.dart';
import 'package:intheloopapp/ui/login/login_cubit.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

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
        child: const LoginForm(),
      ),
    );
  }
}
