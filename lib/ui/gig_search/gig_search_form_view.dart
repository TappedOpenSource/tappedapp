import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/forms/tapped_form/tapped_form.dart';
import 'package:intheloopapp/ui/gig_search/components/add_collaborators_form.dart';
import 'package:intheloopapp/ui/gig_search/components/venue_filter_form.dart';
import 'package:intheloopapp/ui/gig_search/gig_search_cubit.dart';
import 'package:intheloopapp/utils/premium_builder.dart';

class GigSearchFormView extends StatelessWidget {
  const GigSearchFormView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumBuilder(
      builder: (context, isPremium) {
        return BlocBuilder<GigSearchCubit, GigSearchState>(
          builder: (context, state) {
            return TappedForm(
              cancelButton: true,
              questions: [
                FormQuestion(
                  validator: () {
                    if (state.place.isNone()) {
                      return false;
                    }

                    if (state.genres.isEmpty) {
                      return false;
                    }

                    return true;
                  },
                  child: const VenueFilterForm(),
                ),
                const FormQuestion(
                  child: AddCollaboratorsForm(),
                ),
              ],
              onSubmit: () {
                if (!isPremium) {
                  context.push(
                    PaywallPage(),
                  );
                  return;
                }

                context.read<GigSearchCubit>().searchVenues().catchError((
                    error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      content: Text(
                        error.toString(),
                      ),
                    ),
                  );
                });
              },
            );
          },
        );
      },
    );
  }
}
