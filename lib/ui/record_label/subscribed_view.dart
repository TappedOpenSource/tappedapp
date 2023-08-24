import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/generation_bloc/generation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/record_label/components/avatars_preview.dart';
import 'package:intheloopapp/ui/record_label/components/claim_chip.dart';
import 'package:intheloopapp/ui/record_label/cubit/subscribed_cubit.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class SubscribedView extends StatelessWidget {
  const SubscribedView({
    required this.claim,
    super.key,
  });

  final String claim;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final database = context.read<DatabaseRepository>();
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        final isOutOfCredits = currentUser.aiCredits <= 0;
        return BlocProvider(
          create: (context) => SubscribedCubit(
            database: database,
            currentUser: currentUser,
          )..initAvatars(),
          child: Scaffold(
            backgroundColor: theme.colorScheme.background,
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'your AI team',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                  ClaimChip(
                    claim: claim,
                  ),
                ],
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: double.infinity),
                Text(
                  'credits: ${currentUser.aiCredits}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: isOutOfCredits ? Colors.red : Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const AvatarsPreview(),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 32,
                    ),
                    child: CupertinoButton.filled(
                      onPressed: isOutOfCredits
                          ? null
                          : () {
                              context.read<GenerationBloc>().add(
                                    const ResetGeneration(),
                                  );
                              context.push(
                                GenerateAvatarPage(),
                              );
                            },
                      child: Text(
                        'generate avatar',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: isOutOfCredits ? Colors.grey : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
