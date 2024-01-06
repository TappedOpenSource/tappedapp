import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/common/tapped_app_bar.dart';

class AdminView extends StatelessWidget {
  const AdminView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: const TappedAppBar(
        title: 'Admin',
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(width: double.infinity),
            Text('upload flier'),
            Text('place'),
            Text('start time'),
            Text('end time'),
            Text('title'),
            Text('description'),
            Text('isPaid'),
          ],
        ),
      ),
    );
  }
}
