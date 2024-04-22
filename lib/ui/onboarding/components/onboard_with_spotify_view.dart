import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/forms/spotify_text_field.dart';
import 'package:intheloopapp/ui/onboarding/onboarding_flow_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardWithSpotifyView extends StatelessWidget {
  const OnboardWithSpotifyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "onboard with spotify? (optional)",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Rubik One',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            SpotifyTextField(
              initialValue: state.spotifyUrl.fold(
                    () => '',
                    (a) => a,
              ),
              onChanged: (value) {
                context.read<OnboardingFlowCubit>().spotifyUrlChange(value);
              },
            ),
            GestureDetector(
              onTap: () =>
                  launchUrl(
                    Uri.parse(
                      'https://tappedapp.notion.site/how-do-i-get-my-spotify-url-2d1250547a044071becbe43763a77583',
                    ),
                  ),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'how do I find my spotify artist url?',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.open_in_new,
                      color: Colors.blue,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
