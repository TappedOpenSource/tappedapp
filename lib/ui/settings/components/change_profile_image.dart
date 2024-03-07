import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/ui/settings/settings_cubit.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/default_image.dart';

class ChangeProfileImage extends StatelessWidget {
  const ChangeProfileImage({super.key});

  ImageProvider displayProfileImage(
    Option<File> newProfileImage,
    Option<String> currentProfileImage,
  ) {
    return switch ((newProfileImage, currentProfileImage)) {
    (Some(:final value), _) => FileImage(value),
    (None(), Some(:final value)) => CachedNetworkImageProvider(value),
    (None(), None()) => getDefaultImage(const None()),
    };
  }

  @override
  Widget build(BuildContext context) {
    return CurrentUserBuilder(
      errorWidget: const Center(
        child: Text('An error has occured :/'),
      ),
      builder: (context, currentUser) {
        return BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () =>
                  context.read<SettingsCubit>().handleImageFromGallery(),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: displayProfileImage(
                      state.profileImage,
                      currentUser.profilePicture,
                    ),
                  ),
                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.black54,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 50,
                          color: Colors.white,
                        ),
                        Text(
                          'Change Profile Picture',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
