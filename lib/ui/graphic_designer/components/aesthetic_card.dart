import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/generation_bloc/generation_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';

class AestheticCard extends StatelessWidget {
  const AestheticCard({
    required this.prompt,
    required this.imagePath,
    super.key,
  });

  final String prompt;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerationBloc, GenerationState>(
      builder: (context, state) {
        return InkWell(
          onTap: () => context.read<GenerationBloc>().add(
                SelectPrompt(
                  prompt: prompt,
                ),
              ),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                width: 6,
                color: () {
                  return switch (state.selectedPrompt) {
                    None() => Colors.transparent,
                    Some(:final value) =>
                      value == prompt ? Colors.blue : Colors.transparent,
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