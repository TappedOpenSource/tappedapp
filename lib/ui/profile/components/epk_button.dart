import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/ui/settings/settings_cubit.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:url_launcher/url_launcher.dart';

class EPKButton extends StatelessWidget {
  const EPKButton({super.key});

  Widget _buildCurrentEpk(
    BuildContext context, {
    required Option<String> pressKitUrl,
  }) {
    return switch (pressKitUrl) {
      None() => const SizedBox.shrink(),
      Some(:final value) => Container(
          padding: const EdgeInsets.all(8),
          child: TextButton(
            onPressed: () {
              final uri = Uri.parse(value);
              launchUrl(uri);
            },
            child: Text('View Current EPK'),
          ),
        ),
    };
  }

  Widget _buildUploadedEpk(
    BuildContext context, {
    required Option<File> pressKitFile,
  }) {
    final theme = Theme.of(context);
    return switch (pressKitFile) {
      None() => GestureDetector(
          onTap: () {
            context.read<SettingsCubit>().pickPressKit();
          },
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorScheme.onSurface.withOpacity(0.1),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 16),
                      Icon(
                        Icons.upload_file,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Upload New EPK',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      Some(:final value) => Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 16),
                      Text(
                        '✅ EPK Uploaded',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<SettingsCubit>().removePressKit();
                        },
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        final currentPressKitUrl =
            currentUser.performerInfo.flatMap((t) => t.pressKitUrl);
        return BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return Column(
              children: [
                _buildUploadedEpk(
                  context,
                  pressKitFile: state.pressKitFile,
                ),
                _buildCurrentEpk(
                  context,
                  pressKitUrl: currentPressKitUrl,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
