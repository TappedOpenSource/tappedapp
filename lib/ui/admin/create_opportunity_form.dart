import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/admin/create_opportunity_cubit.dart';
import 'package:intheloopapp/ui/common/form_item.dart';
import 'package:intheloopapp/ui/forms/location_text_field.dart';
import 'package:intheloopapp/utils/default_image.dart';

class CreateOpportunityForm extends StatelessWidget {
  const CreateOpportunityForm({super.key});

  // This function displays a CupertinoModalPopup with a reasonable fixed height
  void _showDialog(BuildContext context, Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  ImageProvider _displayPickedImage(
    Option<File> newProfileImage,
    Option<String> currentProfileImage,
  ) {
    return switch (newProfileImage) {
      Some(:final value) => FileImage(value),
      None() => switch (currentProfileImage) {
          Some(:final value) => CachedNetworkImageProvider(value),
          // ignore: unnecessary_cast
          None() => getDefaultImage(const None()),
        },
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOpportunityCubit, CreateOpportunityState>(
      builder: (context, state) {
        final cubit = context.read<CreateOpportunityCubit>();
        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(width: double.infinity),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => context
                        .read<CreateOpportunityCubit>()
                        .handleImageFromGallery(),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: _displayPickedImage(
                            state.pickedPhoto,
                            const None(),
                          ),
                        ),
                        const CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.black54,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 50,
                                color: Colors.white,
                              ),
                              Text(
                                'Upload Flier',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.title),
                  labelText: 'opportunity title',
                  hintText: 'open mic night',
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: cubit.updateTitle,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'add a description',
                ),
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                maxLength: 256,
                onChanged: (input) => context
                    .read<CreateOpportunityCubit>()
                    .updateDescription(input),
              ),
              LocationTextField(
                initialPlace: state.placeData,
                onChanged: cubit.onLocationChanged,
              ),
              CupertinoSlidingSegmentedControl(
                groupValue: state.isPaid,
                onValueChanged: (bool? value) {
                  cubit.updatePaid(isPaid: value ?? false);
                },
                children: const {
                  false: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          CupertinoIcons.xmark,
                        ),
                        Text(
                          'unpaid',
                          style: TextStyle(
                            // color: tappedAccent,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  true: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          CupertinoIcons.money_dollar,
                          // color: tappedAccent,
                        ),
                        Text(
                          'paid',
                          style: TextStyle(
                            // color: tappedAccent,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: Text(
                  "if you don't know the exact start and end time then just get the date correct",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
              FormItem(
                children: [
                  const Text('Start Time'),
                  CupertinoButton(
                    onPressed: () => _showDialog(
                      context,
                      CupertinoDatePicker(
                        initialDateTime: state.startTime.value,
                        minimumDate: DateTime.now().subtract(
                          const Duration(hours: 1),
                        ),
                        use24hFormat: true,
                        onDateTimeChanged: (DateTime newDateTime) {
                          context
                              .read<CreateOpportunityCubit>()
                              .updateStartTime(newDateTime);
                        },
                      ),
                    ),
                    child: Text(
                      state.formattedStartTime,
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                ],
              ),
              FormItem(
                children: <Widget>[
                  const Text('End Time'),
                  CupertinoButton(
                    onPressed: () => _showDialog(
                      context,
                      CupertinoDatePicker(
                        initialDateTime: state.endTime.value,
                        minimumDate: state.startTime.value,
                        use24hFormat: true,
                        onDateTimeChanged: (DateTime newDateTime) {
                          context
                              .read<CreateOpportunityCubit>()
                              .updateEndTime(newDateTime);
                        },
                      ),
                    ),
                    child: Text(
                      state.formattedEndTime,
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CupertinoButton.filled(
                onPressed: () {
                  if (state.loading) {
                    return;
                  }

                  context
                      .read<CreateOpportunityCubit>()
                      .submit()
                      .onError((error, stackTrace) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.red,
                        content: Text('Error: $error'),
                      ),
                    );
                  }).then((value) {
                    context.pop();
                  });
                },
                child: state.loading
                    ? const CupertinoActivityIndicator()
                    : const Text('full send'),
              ),
            ],
          ),
        );
      },
    );
  }
}
