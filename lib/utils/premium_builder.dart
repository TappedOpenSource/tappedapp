import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/subscription_bloc/subscription_bloc.dart';

class PremiumBuilder extends StatelessWidget {
  const PremiumBuilder({
    required this.builder,
    super.key,
  });

  final Widget Function(BuildContext, bool) builder;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SubscriptionBloc, SubscriptionState, bool>(
      selector: (state) => state is Initialized ? state.subscribed : false,
      builder: builder,
    );
  }
}
