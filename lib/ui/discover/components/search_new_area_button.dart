import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/discover/discover_cubit.dart';

class SearchNewAreaButton extends StatelessWidget {
  const SearchNewAreaButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    return BlocBuilder<DiscoverCubit, DiscoverState>(
      builder: (context, state) {
        if (!state.resultsExpired) {
          return const SizedBox.shrink();
        }

        return CupertinoButton(
          onPressed: context.read<DiscoverCubit>().searchNewBounds,
          color: onSurface.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                color: onSurface,
              ),
              const SizedBox(width: 8),
              Text(
                'search new area',
                style: TextStyle(
                  color: onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
