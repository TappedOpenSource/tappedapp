import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class ClearFiltersButton extends StatelessWidget {
  const ClearFiltersButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.search.add(ClearFilters());
      },
      child: const Text(
        'Clear Filters',
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }
}
