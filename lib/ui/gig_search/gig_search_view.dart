import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/common/tapped_app_bar.dart';

class GigSearchView extends StatelessWidget {
  const GigSearchView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: const TappedAppBar(
        title: 'Opportunities',
      ),
      body: const Center(
        child: Text('Gig Search'),
      ),
    );
  }
}
