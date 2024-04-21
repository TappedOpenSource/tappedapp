import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/forms/spotify_text_field.dart';
import 'package:intheloopapp/ui/forms/username_text_field.dart';
import 'package:intheloopapp/ui/onboarding/onboarding_flow_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingUsernameView extends StatelessWidget {
  const OnboardingUsernameView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "what's your handle?",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Rubik One',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            UsernameTextField(
              onChanged: (input) => context
                  .read<OnboardingFlowCubit>()
                  .usernameChange(input ?? ''),
              initialValue: state.username.value,
            ),
            // add place to put spotify url
            SpotifyTextField(
              initialValue: state.spotifyUrl,
              onChanged: (_) {}
            ),
            GestureDetector(
              onTap: () => launchUrl(
                Uri.parse(
                  'https://tappedapp.notion.site/how-do-i-get-my-spotify-url-2d1250547a044071becbe43763a77583',
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'how do I find my spotify artist url?',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 5),
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
