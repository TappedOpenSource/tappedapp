import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intheloopapp/domains/models/spotify_artist.dart';
import 'package:intheloopapp/ui/onboarding/components/onboard_with_spotify_view.dart';
import 'package:intheloopapp/ui/onboarding/onboarding_flow_cubit.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class OnboardWithSpotifyButton extends StatelessWidget {
  const OnboardWithSpotifyButton({
    this.initialValue,
    this.onChanged,
    super.key,
  });

  final String? initialValue;
  final void Function(SpotifyArtist)? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    return BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
      builder: (context, state) {
        return CupertinoButton(
          onPressed: () {
            showCupertinoModalBottomSheet<void>(
              context: context,
              builder: (context) {
                return OnboardWithSpotifyView(
                  initialValue: initialValue,
                  onChanged: onChanged,
                );
              },
            );
          },
          color: Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
          padding: const EdgeInsets.all(12),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.spotify,
                size: 20,
                color: Colors.green,
              ),
              SizedBox(width: 10),
              Text(
                'onboard with spotify',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
