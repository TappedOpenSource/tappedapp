import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';
import 'package:intheloopapp/ui/settings/components/label_multi_select.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class LabelFilter extends StatelessWidget {
  const LabelFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return LabelMultiSelect(
          initialValue: state.labels,
          onConfirm: (values) {
            context.search.add(
              SetAdvancedSearchFilters(
                labels: values
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
