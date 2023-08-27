import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/generation_bloc/generation_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';

class AestheticCard extends StatelessWidget {
  const AestheticCard({
    required this.name,
    required this.imagePath,
    super.key,
  });

  final String name;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerationBloc, GenerationState>(
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
  }
}
