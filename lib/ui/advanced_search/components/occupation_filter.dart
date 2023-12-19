import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';
import 'package:intheloopapp/ui/settings/components/occupation_selection.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class OccupationFilter extends StatelessWidget {
  const OccupationFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return OccupationSelection(
          initialValue: state.occupations,
          onConfirm: (values) {
            context.search.add(
              SetAdvancedSearchFilters(
                occupations: values
                    .where(
                      (element) => element != null,
                    )
                    .whereType<String>()
                    .toList(),
              ),
            );
          },
        );
      },
    );
  }
}
