import 'package:flutter/cupertino.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class CustomClaimsBuilder extends StatelessWidget {
  const CustomClaimsBuilder({
    required this.builder,
    super.key,
  });

  final Widget Function(BuildContext, List<CustomClaim>) builder;

  @override
  Widget build(BuildContext context) {
    final auth = context.auth;
    return FutureBuilder<List<CustomClaim>>(
      future: auth.getCustomClaims(),
      builder: (context, snapshot) {
        final claims = snapshot.data ?? [];
        return builder(context, claims);
      },
    );
  }
}
