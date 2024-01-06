import 'package:flutter/cupertino.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class AdminBuilder extends StatelessWidget {
  const AdminBuilder({
    required this.builder,
    super.key,
  });

  // ignore: avoid_positional_boolean_parameters
  final Widget Function(BuildContext, bool) builder;

  @override
  Widget build(BuildContext context) {
    final auth = context.auth;
    return FutureBuilder<bool>(
      future: auth.getAdminClaim(),
      builder: (context, snapshot) {
        final isAdmin = snapshot.data;
        return switch (isAdmin) {
          null => builder(context, false),
          _ => builder(context, isAdmin),
        };
      },
    );
  }
}
