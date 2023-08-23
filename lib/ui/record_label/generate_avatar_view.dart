import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/generation_bloc/generation_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/common/tapped_app_bar.dart';
import 'package:intheloopapp/ui/record_label/generate_avatar_confirmation_view.dart';

class GenerateAvatarView extends StatelessWidget {
  const GenerateAvatarView({super.key});

  Widget _aestheticCard(
    BuildContext context, {
    required String name,
    required String imagePath,
  }) =>
      BlocBuilder<GenerationBloc, GenerationState>(
        builder: (context, state) {
          return InkWell(
            onTap: () => context.read<GenerationBloc>().add(
                  SelectAesthetic(
                    aesthetic: name,
                  ),
                ),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 6,
                  color: () {
                    return switch (state.selectedAesthetic) {
                      None() => Colors.transparent,
                      Some(:final value) =>
                        value == name ? Colors.blue : Colors.transparent,
                    };
                  }(),
                ),
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey,
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      );

  Widget _pickAestheticView(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: const TappedAppBar(
          title: 'Pick Aesthetic',
        ),
        body: Column(
          children: [
            SizedBox(
              height: 600,
              child: GridView.count(
                padding: const EdgeInsets.symmetric(vertical: 50),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _aestheticCard(
                    context,
                    name: 'acrylic',
                    imagePath: 'assets/aesthetics/acrylic.png',
                  ),
                ],
              ),
            ),
            BlocBuilder<GenerationBloc, GenerationState>(
              builder: (context, state) {
                return CupertinoButton.filled(
                  onPressed: () {
                    return switch (state.selectedAesthetic) {
                      None() => null,
                      Some(:final value) => () {
                          context.read<GenerationBloc>().add(
                                GenerateAvatar(
                                  aesthetic: value,
                                ),
                              );
                        },
                    };
                  }(),
                  child: const Text(
                    'Create',
                  ),
                );
              },
            ),
            CupertinoButton(
              onPressed: () => context.pop(),
              child: const Text(
                'cancel',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildSuccess(
    BuildContext context,
    List<String> imageUrls,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const TappedAppBar(
        title: 'Avatar Generated',
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: imageUrls[index],
                );
              },
            ),
          ),
          CupertinoButton(
            onPressed: () {
              context.read<GenerationBloc>().add(
                    const ResetGeneration(),
                  );
              context.pop();
            },
            child: const Text(
              'Done',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerationBloc, GenerationState>(
      builder: (context, state) {
        if (state.loading) {
          return const GenerateAvatarConfirmationView();
        }

        return switch (state.imageUrls) {
          None() => _pickAestheticView(context),
          Some(:final value) => _buildSuccess(context, value),
        };
      },
    );
  }
}
