import 'package:flutter/material.dart';

class AddPastBookingView extends StatelessWidget {
  const AddPastBookingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(),
      body: const Column(
        children: [
          Text('AddPastBookingView'),
          Text('name of the event'),
          Text('when was it'),
          Text('where was it'),
          Text('how much were you paid?'),
        ],
      ),
    );
  }
}
