import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/generation_bloc/generation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/record_label/components/avatars_preview.dart';
import 'package:intheloopapp/ui/record_label/cubit/graphic_designer_cubit.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class AvatarGeneratorContainer extends StatelessWidget {
  const AvatarGeneratorContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return BlocBuilder<GraphicDesignerCubit, GraphicDesignerState>(
          builder: (context, state) {
            return Column(
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
                      onPressed: currentUser.isOutOfCredits
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
                          color: currentUser.isOutOfCredits
                              ? Colors.grey
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
