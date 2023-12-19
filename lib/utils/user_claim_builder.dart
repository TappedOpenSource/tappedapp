import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/ui/loading/loading_view.dart';
import 'package:intheloopapp/ui/record_label/unsubscribed_view.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class UserClaimBuilder extends StatelessWidget {
  const UserClaimBuilder({
    required this.builder,
    super.key,
  });

  final Widget Function(BuildContext, String) builder;

  @override
  Widget build(BuildContext context) {
    final auth = context.auth;
    return FutureBuilder<Option<String>>(
      future: auth.getCustomClaim(),
      builder: (context, snapshot) {
        final claim = snapshot.data;
        return switch (claim) {
          null => const LoadingView(),
          None() => const UnsubscribedView(),
          Some(:final value) => builder(context, value),
        };
      },
    );
  }
}
