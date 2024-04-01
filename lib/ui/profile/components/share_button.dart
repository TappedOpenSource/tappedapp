import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/share_profile/share_profile_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return CupertinoButton(
          onPressed: () =>
              showCupertinoModalBottomSheet(
                context: context,
                builder: (context) => ShareProfileView(
                  userId: state.visitedUser.id,
                  user: Option.of(state.visitedUser),
                ),
              ),
          color: theme.colorScheme.onSurface.withOpacity(0.1),
          padding: const EdgeInsets.all(12),
          child: Text(
            'share',
            style: TextStyle(
              fontSize: 17,
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
