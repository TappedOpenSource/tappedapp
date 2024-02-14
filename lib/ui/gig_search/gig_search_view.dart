import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/ui/gig_search/gig_search_cubit.dart';
import 'package:intheloopapp/ui/gig_search/gig_search_form_view.dart';
import 'package:intheloopapp/ui/gig_search/gig_search_results_view.dart';

class GigSearchView extends StatelessWidget {
  const GigSearchView({
    super.key,
  });

  Widget _viewSelector() {
    return BlocBuilder<GigSearchCubit, GigSearchState>(
      builder: (context, state) {
        return switch (state.formStatus) {
          FormzSubmissionStatus.initial => GigSearchFormView(),
          FormzSubmissionStatus.inProgress => const Center(
            child: CupertinoActivityIndicator(),
          ),
          FormzSubmissionStatus.success => GigSearchResultsView(),
          FormzSubmissionStatus.failure => GigSearchFormView(),
          FormzSubmissionStatus.canceled => GigSearchFormView(),
        };
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider<GigSearchCubit>(
      create: (context) => GigSearchCubit(),
      child: _viewSelector(),
    );
  }
}
