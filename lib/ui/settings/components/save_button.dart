import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/prod/firestore_database_impl.dart';
import 'package:intheloopapp/ui/settings/settings_cubit.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/spotify_utils.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () async {
            final messenger = ScaffoldMessenger.of(context);
            try {
              await context.read<SettingsCubit>().saveProfile();
            } on HandleAlreadyExistsException {
              messenger.showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    'Username already exists',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            } on InvalidSpotifyUrlException {
              messenger.showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    'invalid spotify URL',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ),
              );

            } catch (e, s) {
              logger.error('error saving profile', error: e, stackTrace: s);
              messenger.showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    'Error saving profile',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
            // Navigator.pop(context);
          },
          child: Container(
            width: 100,
            height: 35,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: tappedAccent,
            ),
            child: const Center(
              child: Text(
                'Save',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
