import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intheloopapp/ui/forms/tapped_form/tapped_form.dart';
import 'package:intheloopapp/ui/gig_search/components/add_collaborators_form.dart';
import 'package:intheloopapp/ui/gig_search/components/venue_filter_form.dart';


class GigSearchFormView extends StatelessWidget {
  const GigSearchFormView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TappedForm(
      questions: [
        FormQuestion(
          child: VenueFilterForm(),
        ),
        FormQuestion(
          child: AddCollaboratorsForm(),
        ),
      ],
    );
  }
}
