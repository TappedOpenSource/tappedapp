import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/ui/forms/artist_name_text_field.dart';
import 'package:intheloopapp/ui/onboarding/components/onboard_with_spotify_button.dart';
import 'package:intheloopapp/ui/onboarding/onboarding_flow_cubit.dart';

class OnboardingUsernameView extends StatelessWidget {
  const OnboardingUsernameView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
      builder: (context, state) {
        return switch (state.spotifyArtist) {
          None() =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(
                  //   "let's get your set up",
                  //   style: TextStyle(
                  //     fontSize: 28,
                  //     fontFamily: 'Rubik One',
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // Text(
                  //   'this info will help you get booked',
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     fontWeight: FontWeight.w300,
                  //     color: Colors.grey,
                  //   ),
                  // ),
                  const Text(
                    "what's your performer name?",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Rubik One',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'e.g. DJ Drama, Doja Cat, etc.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ArtistNameTextField(
                    onChanged: (input) =>
                        context
                            .read<OnboardingFlowCubit>()
                            .artistNameChange(input ?? ''),
                    initialValue: state.artistName,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          height: 0,
                          thickness: 0.5,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'or',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Divider(
                          height: 0,
                          thickness: 0.5,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OnboardWithSpotifyButton(
                          initialValue: state.spotifyArtist.map((s) => s.id)
                              .fold(
                                () => '',
                                (a) => 'https://open.spotify.com/artist/$a',
                          ),
                          onChanged: (value) {
                            context
                                .read<OnboardingFlowCubit>()
                                .spotifyArtistChange(Option.of(value));
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          Some(:final value) => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: double.infinity),
                const Spacer(),
                if (value.images.isNotEmpty)
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          value.images.first.url,
                        ),
                      ),
                    ),
                  ),
                Text(
                  value.name.getOrElse(() => '<artist name unknown>'),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    children: value.genres.map((genre) {
                      return Chip(label: Text(genre));
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        };
      },
    );
  }
}
