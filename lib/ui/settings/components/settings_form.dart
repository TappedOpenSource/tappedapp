import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/domains/models/genre.dart';
import 'package:intheloopapp/ui/forms/artist_name_text_field.dart';
import 'package:intheloopapp/ui/forms/bio_text_field.dart';
import 'package:intheloopapp/ui/forms/instagram_text_field.dart';
import 'package:intheloopapp/ui/forms/location_text_field.dart';
import 'package:intheloopapp/ui/forms/spotify_text_field.dart';
import 'package:intheloopapp/ui/forms/tiktok_text_field.dart';
import 'package:intheloopapp/ui/forms/twitter_text_field.dart';
import 'package:intheloopapp/ui/forms/username_text_field.dart';
import 'package:intheloopapp/ui/forms/youtube_text_field.dart';
import 'package:intheloopapp/ui/settings/components/genre_selection.dart';
import 'package:intheloopapp/ui/settings/components/label_selection.dart';
import 'package:intheloopapp/ui/settings/components/occupation_selection.dart';
import 'package:intheloopapp/ui/settings/components/theme_switch.dart';
import 'package:intheloopapp/ui/settings/settings_cubit.dart';
import 'package:intheloopapp/ui/tagging/search/tag_detector_field.dart';
import 'package:intheloopapp/ui/themes.dart';

class SettingsForm extends StatelessWidget {
   SettingsForm({super.key});
  TextEditingController tagController = TextEditingController();


TagDetectorField makeTagDetector(
  String initialValue, 
  BuildContext context, 
  SettingsState state) {

    BioTextField textField = makeTaggableBio(initialValue, context,  state); 

  return TagDetectorField(
                controller: tagController,
                textField: textField,
                //onChangedAnc: (value) => {print('avsz onChanged: $value')},
              );
}
BioTextField makeTaggableBio(
  String initialValue, 
  BuildContext context,
  SettingsState state){

  return BioTextField(
                onChanged: (value) =>
                    context.read<SettingsCubit>().changeBio(value ?? ''),
                initialValue: state.bio,
                controller: tagController,
              );
}

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

              makeTagDetector(state.bio, context, state),
              
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
                initialPlaceId: state.placeId,
              ),
              TwitterTextField(
                initialValue: state.twitterHandle,
                onChanged: (value) =>
                    context.read<SettingsCubit>().changeTwitter(value),
              ),
              InstagramTextField(
                initialValue: state.instagramHandle,
                onChanged: (value) =>
                    context.read<SettingsCubit>().changeInstagram(value),
              ),
              TikTokTextField(
                initialValue: state.tiktokHandle,
                onChanged: (value) =>
                    context.read<SettingsCubit>().changeTikTik(value),
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
