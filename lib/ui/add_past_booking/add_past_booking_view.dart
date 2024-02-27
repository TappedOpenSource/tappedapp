import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/add_past_booking/add_past_booking_cubit.dart';
import 'package:intheloopapp/ui/add_past_booking/components/amount_paid_field.dart';
import 'package:intheloopapp/ui/add_past_booking/components/event_date_field.dart';
import 'package:intheloopapp/ui/add_past_booking/components/event_location_field.dart';
import 'package:intheloopapp/ui/add_past_booking/components/event_name_field.dart';
import 'package:intheloopapp/ui/add_past_booking/components/import_confirmation.dart';
import 'package:intheloopapp/ui/add_past_booking/components/upload_flier_field.dart';
import 'package:intheloopapp/ui/forms/tapped_form/tapped_form.dart';

class AddPastBookingView extends StatelessWidget {
  const AddPastBookingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) => AddPastBookingCubit(),
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(),
        body: TappedForm(
          questions: [
            (
              const EventDateField(),
              () => true,
            ),
            (
              const EventLocationField(),
              () => true,
            ),
            (
              const AmountPaidField(),
              () => true,
            ),
            (
              const EventNameField(),
              () => true,
            ),
            (
              const UploadFlierField(),
              () => true,
            ),
            (
              const ImportConfirmation(),
              () => true,
            ),
          ],
        ),
      ),
    );
  }
}
