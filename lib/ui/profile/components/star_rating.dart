import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  const StarRating({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          '5.0',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        Text('Rating'),
      ],
    );
  }
}
