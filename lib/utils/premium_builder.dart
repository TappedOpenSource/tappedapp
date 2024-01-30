import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class PremiumBuilder extends StatelessWidget {
  const PremiumBuilder({
    required this.builder,
    super.key,
  });

  final Widget Function(BuildContext, Option<String>) builder;

  @override
  Widget build(BuildContext context) {
    final auth = context.auth;
    return FutureBuilder<Option<String>>(
      future: auth.getStripeClaim(),
      builder: (context, snapshot) {
        final claim = snapshot.data;
        return switch (claim) {
          null => builder(context, const None()),
          _ => builder(context, claim),
        };
      },
    );
  }
}
