import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/record_label/components/claim_chip.dart';
import 'package:intheloopapp/ui/social_media_manager/components/post_idea_generator_container.dart';
import 'package:intheloopapp/ui/social_media_manager/cubit/social_media_manager_cubit.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/user_claim_builder.dart';

class SocialMediaManagerView extends StatelessWidget {
  const SocialMediaManagerView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return UserClaimBuilder(
          builder: (context, claim) {
            return BlocProvider(
              create: (context) => SocialMediaManagerCubit(
                currentUser: currentUser,
                onboardingBloc: context.read<OnboardingBloc>(),
              ),
              child: Scaffold(
                backgroundColor: theme.colorScheme.background,
                appBar: AppBar(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'social media',
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
                    PostIdeaGeneratorContainer(),
                    // SizedBox(height: 16),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //     vertical: 4,
                    //     horizontal: 32,
                    //   ),
                    //   child: Divider(
                    //     color: Colors.grey,
                    //   ),
                    // ),
                    // SizedBox(height: 16),
                    // AlbumNameGeneratorContainer(),
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
