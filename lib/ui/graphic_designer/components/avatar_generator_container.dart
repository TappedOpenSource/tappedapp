import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/generation_bloc/generation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/graphic_designer/components/avatars_preview.dart';
import 'package:intheloopapp/ui/graphic_designer/cubit/graphic_designer_cubit.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class AvatarGeneratorContainer extends StatelessWidget {
  const AvatarGeneratorContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        // final noEnoughCredits = currentUser.aiCredits < 5;
        return BlocBuilder<GraphicDesignerCubit, GraphicDesignerState>(
          builder: (context, state) {
            return switch (state.hasImageModel) {
              false => const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('no image model found'),
                    SizedBox(height: 4),
                    Text(
                      // ignore: lines_longer_than_80_chars
                      'contact support@tapped.ai to get one created for you',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              true => Column(
                  children: [
                    const AvatarsPreview(),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 32,
                        ),
                        child: CupertinoButton.filled(
                          onPressed: () {
                            context.read<GenerationBloc>().add(
                                  const ResetGeneration(),
                                );
                            context.push(
                              GenerateAvatarPage(),
                            );
                          },
                          child: const Text(
                            'generate avatar',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            };
          },
        );
      },
    );
  }
}
