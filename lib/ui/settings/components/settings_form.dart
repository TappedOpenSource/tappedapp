import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/domains/models/genre.dart';
import 'package:intheloopapp/ui/forms/artist_name_text_field.dart';
import 'package:intheloopapp/ui/forms/bio_text_field.dart';
import 'package:intheloopapp/ui/forms/instagram_followers_text_field.dart';
import 'package:intheloopapp/ui/forms/instagram_text_field.dart';
import 'package:intheloopapp/ui/forms/location_text_field.dart';
import 'package:intheloopapp/ui/forms/spotify_text_field.dart';
import 'package:intheloopapp/ui/forms/tiktok_followers_text_field.dart';
import 'package:intheloopapp/ui/forms/tiktok_text_field.dart';
import 'package:intheloopapp/ui/forms/twitter_followers_text_field.dart';
import 'package:intheloopapp/ui/forms/twitter_text_field.dart';
import 'package:intheloopapp/ui/forms/username_text_field.dart';
import 'package:intheloopapp/ui/forms/youtube_text_field.dart';
import 'package:intheloopapp/ui/settings/components/genre_selection.dart';
import 'package:intheloopapp/ui/settings/components/label_selection.dart';
import 'package:intheloopapp/ui/settings/components/occupation_selection.dart';
import 'package:intheloopapp/ui/settings/components/theme_switch.dart';
import 'package:intheloopapp/ui/settings/settings_cubit.dart';
import 'package:intheloopapp/ui/themes.dart';

class SettingsForm extends StatelessWidget {
  const SettingsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Form(
          key: state.formKey,
          child: Column(
            children: [
              UsernameTextField(
                initialValue: state.username,
                onChanged: (input) {
                  if (input != null) {
                    context.read<SettingsCubit>().changeUsername(input);
                  }
                },
              ),
              ArtistNameTextField(
                onChanged: (input) =>
                    context.read<SettingsCubit>().changeArtistName(input ?? ''),
                initialValue: state.artistName,
              ),
              BioTextField(
                onChanged: (value) =>
                    context.read<SettingsCubit>().changeBio(value ?? ''),
                initialValue: state.bio,
              ),
              OccupationSelection(
                initialValue: state.occupations,
                onConfirm: (values) {
                  context.read<SettingsCubit>().changeOccupations(
                        values
                            .where(
                              (element) => element != null,
                            )
                            .whereType<String>()
                            .toList(),
                      );
                },
              ),
              const LabelSelection(),
              GenreSelection(
                initialValue: state.genres,
                onConfirm: (values) {
                  context.read<SettingsCubit>().changeGenres(
                        values
                            .where(
                              (element) => element != null,
                            )
                            .whereType<Genre>()
                            .toList(),
                      );
                },
              ),
              LocationTextField(
                onChanged: (place, placeId) =>
                    context.read<SettingsCubit>().changePlace(place, placeId),
                initialPlace: state.place,
              ),
              TwitterTextField(
                initialValue: state.twitterHandle,
                onChanged: (value) =>
                    context.read<SettingsCubit>().changeTwitter(value),
              ),
              TwitterFollowersTextField(
                initialValue: state.twitterFollowers,
                onChanged: (value) =>
                    context.read<SettingsCubit>().changeTwitterFollowers(
                          value,
                        ),
              ),
              InstagramTextField(
                initialValue: state.instagramHandle,
                onChanged: (value) =>
                    context.read<SettingsCubit>().changeInstagram(value),
              ),
              InstagramFollowersTextField(
                initialValue: state.instagramFollowers,
                onChanged: (value) =>
                    context.read<SettingsCubit>().changeInstagramFollowers(
                          value,
                        ),
              ),
              TikTokTextField(
                initialValue: state.tiktokHandle,
                onChanged: (value) =>
                    context.read<SettingsCubit>().changeTikTik(value),
              ),
              TikTokFollowersTextField(
                initialValue: state.tiktokFollowers,
                onChanged: (value) =>
                    context.read<SettingsCubit>().changeTikTokFollowers(
                          value,
                        ),
              ),
              SpotifyTextField(
                initialValue: state.spotifyId,
                onChanged: (value) =>
                    context.read<SettingsCubit>().changeSpotify(value),
              ),
              YoutubeTextField(
                initialValue: state.youtubeChannelId,
                onChanged: (value) =>
                    context.read<SettingsCubit>().changeYoutube(value),
              ),
              const SizedBox(height: 15),
              const ThemeSwitch(),
              if (state.status.isInProgress)
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(tappedAccent),
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }
}
