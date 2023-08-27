import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/generation_bloc/generation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/record_label/components/album_name_generator_container.dart';
import 'package:intheloopapp/ui/record_label/components/avatar_generator_container.dart';
import 'package:intheloopapp/ui/record_label/components/avatars_preview.dart';
import 'package:intheloopapp/ui/record_label/components/claim_chip.dart';
import 'package:intheloopapp/ui/record_label/components/credits.dart';
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
            body: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: double.infinity),
                Credits(),
                SizedBox(height: 16),
                AvatarGeneratorContainer(),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 32,
                  ),
                  child: Divider(
                    color: Colors.grey,
                  ),
                ),
                // SizedBox(height: 16),
                // AlbumNameGeneratorContainer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
