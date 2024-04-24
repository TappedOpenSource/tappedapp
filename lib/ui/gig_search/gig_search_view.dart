import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/data/search_repository.dart';
import 'package:intheloopapp/domains/models/genre.dart';
import 'package:intheloopapp/domains/models/performer_info.dart';
import 'package:intheloopapp/ui/gig_search/gig_search_cubit.dart';
import 'package:intheloopapp/ui/gig_search/gig_search_form_view.dart';
import 'package:intheloopapp/ui/gig_search/gig_search_results_view.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class GigSearchView extends StatelessWidget {
  const GigSearchView({
    super.key,
  });

  Widget _viewSelector() {
    return BlocBuilder<GigSearchCubit, GigSearchState>(
      builder: (context, state) {
        return switch (state.formStatus) {
          FormzSubmissionStatus.initial => const GigSearchFormView(),
          FormzSubmissionStatus.inProgress => const Center(
              child: CupertinoActivityIndicator(),
            ),
          FormzSubmissionStatus.success => const GigSearchResultsView(),
          FormzSubmissionStatus.failure => const GigSearchFormView(),
          FormzSubmissionStatus.canceled => const GigSearchFormView(),
        };
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return BlocProvider<GigSearchCubit>(
          create: (context) => GigSearchCubit(
            database: context.read<DatabaseRepository>(),
            search: context.read<SearchRepository>(),
            places: context.read<PlacesRepository>(),
            initialGenres: fromStrings(
              currentUser.performerInfo
                  .map((info) => info.genres)
                  .getOrElse(() => []),
            ),
            initialLocation: currentUser.location,
            category: currentUser.performerInfo
                .map(
                  (t) => t.category,
                )
                .getOrElse(
                  () => PerformerCategory.undiscovered,
                ),
          )..initPlace(),
          child: _viewSelector(),
        );
      },
    );
  }
}
