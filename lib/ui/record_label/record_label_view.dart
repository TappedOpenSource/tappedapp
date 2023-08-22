import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/ui/loading/loading_view.dart';
import 'package:intheloopapp/ui/record_label/subscribed_view.dart';
import 'package:intheloopapp/ui/record_label/unsubscribed_view.dart';

class RecordLabelView extends StatelessWidget {
  const RecordLabelView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthRepository>();
    return FutureBuilder<Option<String>>(
      future: auth.getCustomClaim(),
      builder: (context, snapshot) {
        final claim = snapshot.data;
        return switch (claim) {
          null => const LoadingView(),
          None() => const UnsubscribedView(),
          Some(:final value) => SubscribedView(claim: value),
        };
      },
    );
  }
}
