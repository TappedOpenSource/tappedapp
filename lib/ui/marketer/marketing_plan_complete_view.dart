import 'package:flutter/cupertino.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';

class MarketingPlanCompleteView extends StatelessWidget {
  const MarketingPlanCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoButton(
        onPressed: () => context.pop(),
        child: const Text('Pop'),
      ),
    );
  }
}
