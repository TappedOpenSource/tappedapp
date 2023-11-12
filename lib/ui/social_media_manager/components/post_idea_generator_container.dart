import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/social_media_manager/cubit/social_media_manager_cubit.dart';

class PostIdeaGeneratorContainer extends StatelessWidget {
  const PostIdeaGeneratorContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SocialMediaManagerCubit, SocialMediaManagerState>(
      builder: (context, state) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                Clipboard.setData(
                  const ClipboardData(text: 'fake album name'),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Copied to Clipboard'),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 32,
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            state.postIdea,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 32,
                ),
                child: CupertinoButton.filled(
                  onPressed: () => context
                      .read<SocialMediaManagerCubit>()
                      .generatePostIdea(),
                  child: const Text(
                    'show me the next idea!',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
