import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/add_past_booking/add_past_booking_cubit.dart';
import 'package:intheloopapp/ui/add_past_booking/components/amount_paid_field.dart';
import 'package:intheloopapp/ui/add_past_booking/components/event_date_field.dart';
import 'package:intheloopapp/ui/add_past_booking/components/event_location_field.dart';
import 'package:intheloopapp/ui/add_past_booking/components/event_name_field.dart';
import 'package:intheloopapp/ui/add_past_booking/components/import_summary.dart';
import 'package:intheloopapp/ui/add_past_booking/components/upload_flier_field.dart';
import 'package:intheloopapp/ui/forms/tapped_form/tapped_form.dart';

class ImportForm extends StatelessWidget {
  const ImportForm({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nav = context.read<NavigationBloc>();
    return BlocBuilder<AddPastBookingCubit, AddPastBookingState>(
      builder: (context, state) {
        return TappedForm(
          cancelButton: true,
          questions: [
            (const EventDateField(), () => state.duration != Duration.zero),
            (
              const EventLocationField(),
              () => state.place.isSome() || state.venue.isSome(),
            ),
            (
              AmountPaidField(),
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
              const ImportSummary(),
              () => true,
            ),
          ],
          onSubmit: () async {
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            final cubit = context.read<AddPastBookingCubit>();
            await EasyLoading.show(
              status: 'Submitting booking...',
              maskType: EasyLoadingMaskType.black,
            );
            try {
              await cubit.submitBooking();
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: theme.colorScheme.secondary,
                  content: const Text('Booking submitted'),
                ),
              );
              nav.pop();
            } catch (error) {
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: theme.colorScheme.error,
                  content: const Text('Error submitting booking'),
                ),
              );
            } finally {
              await EasyLoading.dismiss();
            }
          },
        );
      },
    );
  }
}
