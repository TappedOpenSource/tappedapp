import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class PremiumBuilder extends StatelessWidget {
  const PremiumBuilder({
    required this.builder,
    super.key,
  });

  final Widget Function(BuildContext, bool) builder;

  @override
  Widget build(BuildContext context) {
    // final auth = context.auth;
    return FutureBuilder<bool>(
      future: Future.value(false),
      builder: (context, snapshot) {
        final claim = snapshot.data;
        return switch (claim) {
          null => builder(context, false),
          _ => builder(context, claim),
        };
      },
    );
  }
}
