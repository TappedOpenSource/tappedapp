import 'package:flutter/cupertino.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class UserClaimBuilder extends StatelessWidget {
  const UserClaimBuilder({
    required this.builder,
    super.key,
  });

  final Widget Function(BuildContext, Option<String>) builder;

  @override
  Widget build(BuildContext context) {
    final auth = context.auth;
    return FutureBuilder<Option<String>>(
      future: auth.getCustomClaim(),
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
