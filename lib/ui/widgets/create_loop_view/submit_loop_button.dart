import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/ui/views/create_loop/cubit/create_loop_cubit.dart';

class SubmitLoopButton extends StatelessWidget {
  const SubmitLoopButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateLoopCubit, CreateLoopState>(
      builder: (context, state) {
        return FloatingActionButton.extended(
          // color: tappedAccent,
          onPressed: () => context.read<CreateLoopCubit>().createLoop(),
          icon: const Icon(
            Icons.edit_outlined,
          ),
          label: state.status.isInProgress
              ? const CircularProgressIndicator()
              : const Text('Create Loop'),
        );
      },
    );
  }
}