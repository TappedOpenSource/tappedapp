import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/generation_bloc/generation_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/common/tapped_app_bar.dart';
import 'package:intheloopapp/ui/record_label/avatars_generated_view.dart';
import 'package:intheloopapp/ui/record_label/components/aesthetic_card.dart';
import 'package:intheloopapp/ui/record_label/generate_avatar_confirmation_view.dart';

class GenerateAvatarView extends StatelessWidget {
  const GenerateAvatarView({super.key});

  Widget _pickAestheticView(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: const TappedAppBar(
          title: 'Pick Aesthetic',
        ),
        body: Column(
          children: [
            SizedBox(
              height: 600,
              child: GridView.count(
                padding: const EdgeInsets.symmetric(vertical: 50),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: const [
                  AestheticCard(
                    name:
                        "jackson pollock's 'abstract expressionism,' featuring drips, splatters, and energetic brushwork.",
                    imagePath: 'assets/aesthetics/one.png',
                  ),
                  AestheticCard(
                    name:
                        "salvador dalí's 'surrealism,' featuring unexpected juxtapositions, melting objects, and a dreamlike atmosphere.",
                    imagePath: 'assets/aesthetics/two.png',
                  ),
                  AestheticCard(
                    name:
                        "Leonardo da Vinci's 'Renaissance,' with realistic proportions, sfumato technique, and classical composition.",
                    imagePath: 'assets/aesthetics/three.png',
                  ),
                  AestheticCard(
                    name:
                        "Retro comic style artwork, highly detailed spiderman, comic book cover, symmetrical, vibrant",
                    imagePath: 'assets/aesthetics/four.png',
                  ),
                ],
              ),
            ),
            BlocBuilder<GenerationBloc, GenerationState>(
              builder: (context, state) {
                return SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 32,
                    ),
                    child: CupertinoButton.filled(
                      onPressed: () {
                        return switch (state.selectedAesthetic) {
                          None() => null,
                          Some(:final value) => () {
                              context.read<GenerationBloc>().add(
                                    GenerateAvatar(
                                      aesthetic: value,
                                    ),
                                  );
                            },
                        };
                      }(),
                      child: const Text(
                        'Create',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            CupertinoButton(
              onPressed: () => context.pop(),
              child: const Text(
                'cancel',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerationBloc, GenerationState>(
      builder: (context, state) {
        if (state.loading) {
          return const GenerateAvatarConfirmationView();
        }

        return switch (state.imageUrls) {
          None() => _pickAestheticView(context),
          Some(:final value) => AvatarsGeneratedView(
              imageUrls: value,
            )
        };
      },
    );
  }
}
