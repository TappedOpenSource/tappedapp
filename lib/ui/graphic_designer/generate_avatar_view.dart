import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/generation_bloc/generation_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/common/tapped_app_bar.dart';
import 'package:intheloopapp/ui/graphic_designer/components/aesthetic_card.dart';
import 'package:intheloopapp/ui/graphic_designer/generate_avatar_confirmation_view.dart';
import 'package:intheloopapp/ui/graphic_designer/generate_avatar_loading_view.dart';

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
                    prompt:
                        "8k portrait of @subject in the style of jackson pollock's 'abstract expressionism,' featuring drips, splatters, and energetic brushwork.",
                    imagePath: 'assets/aesthetics/one.png',
                  ),
                  AestheticCard(
                    prompt:
                        "8k portrait of @subject in the style of salvador dalí's 'surrealism,' featuring unexpected juxtapositions, melting objects, and a dreamlike atmosphere.",
                    imagePath: 'assets/aesthetics/two.png',
                  ),
                  AestheticCard(
                    prompt:
                        "8k portrait of @subject in the style of Leonardo da Vinci's 'Renaissance,' with realistic proportions, sfumato technique, and classical composition.",
                    imagePath: 'assets/aesthetics/three.png',
                  ),
                  AestheticCard(
                    prompt:
                        '8k portrait of @subject in the style of Retro comic style artwork, highly detailed spiderman, comic book cover, symmetrical, vibrant',
                    imagePath: 'assets/aesthetics/four.png',
                  ),
                  AestheticCard(
                    prompt:
                        'an anime portrait of @subject, an anime portrait, high resolution, sharp features, 32k, super-resolution, sharp focus, depth of field, bokeh, official media, trending on pixiv, oil painting, yoji shinakawa, studio gainax, y2k design, anime, dramatic lighting',
                    imagePath: 'assets/aesthetics/five.png',
                  ),
                  AestheticCard(
                    prompt:
                        '8k high-fashion shot of @subject, ken from barbie on a beach, 8k high-fashion shot, blonde hair, wearing pink, vibrant backdrop of malibu beach, styled in a chic and tailored pastel suit without a tie, iconic windswept hair, flawless dramatic lighting with soft shadows, captured with a 100mm leica summilux f/1.4 lens, showcasing intricate details and capturing the essence of modern masculinity and style',
                    imagePath: 'assets/aesthetics/six.png',
                  ),
                  AestheticCard(
                    prompt:
                        '8k ultra realistic animation of @subject, ultra realistic animation, as disney prince pixar style pixar 3d cartoon style gorgeous tangled beautiful animation character art',
                    imagePath: 'assets/aesthetics/seven.png',
                  ),
                  AestheticCard(
                    prompt:
                        '8k close up linkedin profile picture of @subject, professional jack suite, professional headshots, photo-realistic, 4k, high-resolution image, workplace settings, upper body, modern outfit, professional suit, businessman, blurred background, glass building, office window',
                    imagePath: 'assets/aesthetics/eight.png',
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
                        return switch (state.selectedPrompt) {
                          None() => null,
                          Some(:final value) => () {
                              context.read<GenerationBloc>().add(
                                    GenerateAvatar(
                                      prompt: value,
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
          return const GenerateAvatarLoadingView();
        }

        return switch (state.results) {
          None() => _pickAestheticView(context),
          Some(:final value) => GenerateAvatarConfirmationView(
              results: value,
            )
        };
      },
    );
  }
}
