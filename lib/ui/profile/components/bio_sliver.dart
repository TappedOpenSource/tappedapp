import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:readmore/readmore.dart';

class BioSliver extends StatelessWidget {
  const BioSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final bio = state.visitedUser.bio;
        if (bio.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'About',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              ReadMoreText(
                bio,
                colorClickableText: tappedAccent,
                trimMode: TrimMode.Line,
                trimCollapsedText: ' show more',
                trimExpandedText: ' show less',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  // color: Color(0xFF757575),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
