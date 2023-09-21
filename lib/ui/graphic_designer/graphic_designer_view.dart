import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/ui/graphic_designer/components/avatar_generator_container.dart';
import 'package:intheloopapp/ui/graphic_designer/cubit/graphic_designer_cubit.dart';
import 'package:intheloopapp/ui/record_label/components/claim_chip.dart';
import 'package:intheloopapp/ui/record_label/components/credits.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/user_claim_builder.dart';

class GraphicDesignerView extends StatelessWidget {
  const GraphicDesignerView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final database = context.read<DatabaseRepository>();
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return UserClaimBuilder(
          builder: (context, claim) {
            return BlocProvider(
              create: (context) => GraphicDesignerCubit(
                database: database,
                currentUser: currentUser,
                claim: claim,
              )
              ..checkImageModel()
              ..initAvatars(),
              child: Scaffold(
                backgroundColor: theme.colorScheme.background,
                appBar: AppBar(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'designer',
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
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
