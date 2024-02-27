import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/add_past_booking/add_past_booking_cubit.dart';
import 'package:intheloopapp/ui/common/form_item.dart';

class EventDateField extends StatelessWidget {
  const EventDateField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPastBookingCubit, AddPastBookingState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FormItem(
              children: [
                const Text('Date'),
                CupertinoButton(
                  onPressed: () async {
                    final theDate = await showDatePicker(
                        context: context,
                        initialDate: state.eventStart,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 365 * 10),
                        ),
                        lastDate: DateTime.now().add(
                          const Duration(days: 365),
                        ));

                    if (theDate == null) {
                      return;
                    }

                    context.read<AddPastBookingCubit>().updateStartTime(
                          DateTime(
                            theDate.year,
                            theDate.month,
                            theDate.day,
                            state.eventStart.hour,
                            state.eventStart.minute,
                          ),
                        );
                  },
                  child: Text(
                    state.formattedStartDate,
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
            FormItem(
              children: [
                const Text('Time'),
                CupertinoButton(
                  onPressed: () async {
                    final theTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(state.eventStart),
                    );

                    if (theTime == null) {
                      return;
                    }

                    context.read<AddPastBookingCubit>().updateStartTime(
                          DateTime(
                            state.eventStart.year,
                            state.eventStart.month,
                            state.eventStart.day,
                            theTime.hour,
                            theTime.minute,
                          ),
                        );
                  },
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
              children: [
                const Text('Duration'),
                CupertinoButton(
                  onPressed: () {
                    final cubit = context.read<AddPastBookingCubit>();
                    showCupertinoModalPopup<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 200,
                          color: Colors.white,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CupertinoButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  CupertinoButton(
                                    child: const Text('Done'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                              Expanded(
                                child: CupertinoTimerPicker(
                                  mode: CupertinoTimerPickerMode.hm,
                                  initialTimerDuration: state.duration,
                                  onTimerDurationChanged: (Duration value) {
                                    cubit.updateDuration(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    state.formattedDuration,
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
