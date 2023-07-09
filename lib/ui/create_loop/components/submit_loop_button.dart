import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/create_loop/cubit/create_loop_cubit.dart';

class SubmitLoopButton extends StatelessWidget {
  const SubmitLoopButton({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = context.read<NavigationBloc>();
    return BlocBuilder<CreateLoopCubit, CreateLoopState>(
      builder: (context, state) {
        return FloatingActionButton.extended(
          // color: tappedAccent,
          heroTag: 'submitLoopButton',
          onPressed: () async {
            try {
              final loop = await context.read<CreateLoopCubit>().createLoop();

              return switch (loop) {
                None() => null,
                Some(:final value) => () {
                    // Navigate back to the feed page
                    nav
                      ..changeTab(selectedTab: 0)
                      ..pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green,
                        content: const Text('Loop Created'),
                        action: SnackBarAction(
                          onPressed: () => context.push(
                            LoopPage(
                              loop: value,
                              loopUser: const None(),
                            ),
                          ),
                          label: 'View',
                        ),
                      ),
                    );
                  }()
              };
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('Error Uploading Loop'),
                ),
              );
            }
          },
          icon: const Icon(
            Icons.edit_outlined,
          ),
          label: state.status.isInProgress
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : const Text('Create Loop'),
        );
      },
    );
  }
}
