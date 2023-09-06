import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/generation_bloc/generation_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/common/tapped_app_bar.dart';

class GenerateAvatarConfirmationView extends StatefulWidget {
  const GenerateAvatarConfirmationView({
    required this.results,
    super.key,
  });

  final List<GenerationResult> results;

  @override
  State<GenerateAvatarConfirmationView> createState() =>
      _GenerateAvatarConfirmationViewState();
}

class _GenerateAvatarConfirmationViewState
    extends State<GenerateAvatarConfirmationView> {
  Option<int> _selectedIndex = const None();

  Widget _imageCard(int index, GenerationResult result) => InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = Some(index);
          });
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              width: 6,
              color: () {
                return switch (_selectedIndex) {
                  None() => Colors.transparent,
                  Some(:final value) =>
                    value == index ? Colors.blue : Colors.transparent,
                };
              }(),
            ),
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey,
            image: DecorationImage(
              image: CachedNetworkImageProvider(result.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const TappedAppBar(
        title: 'pick your favorite',
      ),
      body: Column(
        children: [
          SizedBox(
            height: 600,
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 50),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: widget.results.length,
              itemBuilder: (context, index) {
                return _imageCard(index, widget.results[index]);
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 32,
              ),
              child: CupertinoButton.filled(
                onPressed: () {
                  return switch (_selectedIndex) {
                    None() => null,
                    Some(:final value) => () {
                        context.read<GenerationBloc>().add(
                              SaveAvatar(
                                result: widget.results[value],
                              ),
                            );
                        context.pop();
                      },
                  };
                }(),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          CupertinoButton(
            onPressed: () => context.pop(),
            child: const Text(
              'delete all',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
