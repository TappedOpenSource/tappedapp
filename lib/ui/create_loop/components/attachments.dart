import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/ui/create_loop/components/audio_container.dart';
import 'package:intheloopapp/ui/create_loop/components/upload_audio_button.dart';
import 'package:intheloopapp/ui/create_loop/components/upload_image_button.dart';
import 'package:intheloopapp/ui/create_loop/cubit/create_loop_cubit.dart';

class Attachments extends StatelessWidget {
  const Attachments({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateLoopCubit, CreateLoopState>(
      builder: (context, state) {
        if (state.pickedAudio.isSome) {
          return const AudioContainer();
        }

        if (state.pickedImage.isSome) {
          return badges.Badge(
            onTap: context.read<CreateLoopCubit>().removeImage,
            badgeStyle: const badges.BadgeStyle(
              badgeColor: Color.fromARGB(255, 47, 47, 47),
            ),
            badgeContent: const Icon(
              Icons.close_outlined,
              color: Colors.white,
              size: 25,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.file(
                state.pickedImage.unwrap,
                height: 200,
              ),
            ),
          );
        }

        return const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            UploadAudioButton(),
            SizedBox(
              width: 12,
            ),
            UploadImageButton(),
          ],
        );
      },
    );
  }
}
