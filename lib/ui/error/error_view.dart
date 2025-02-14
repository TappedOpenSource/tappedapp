import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/ui/common/tapped_app_bar.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TappedAppBar(title: 'Error'),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(FontAwesomeIcons.faceFrown),
            const Text('an error has occurred :/'),
            const Text('try logging out and logging back in'),
            FilledButton(
              onPressed: () {
                try {
                  context.authentication.add(LoggedOut());
                } catch (e, s) {
                  logger.error(
                    'error logging out',
                    error: e,
                    stackTrace: s,
                  );
                }
              },
              child: const Text('logout'),
            ),
            const Text("if that doesn't work"),
            const Text('send an email to support@tapped.ai'),
            const Text('or DM us on instagram @tappedai'),
          ],
        ),
      ),
    );
  }
}
