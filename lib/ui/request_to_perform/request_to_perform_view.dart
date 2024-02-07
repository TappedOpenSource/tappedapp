import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/common/social_following_menu.dart';
import 'package:intheloopapp/ui/request_to_perform/components/past_bookings_slider.dart';
import 'package:intheloopapp/ui/user_tile.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class RequestToPerformView extends StatefulWidget {
  const RequestToPerformView({
    required this.bookingEmail,
    required this.venue,
    super.key,
  });

  final String bookingEmail;
  final UserModel venue;

  @override
  State<RequestToPerformView> createState() => _RequestToPerformViewState();
}

class _RequestToPerformViewState extends State<RequestToPerformView> {
  String _note = '';
  List<Booking> _latestBookings = [];
  UserModel get _venue => widget.venue;
  String get _bookingEmail => widget.bookingEmail;


  @override
  void initState() {
    super.initState();
    _latestBookings = [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final database = context.database;
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return Scaffold(
          backgroundColor: theme.colorScheme.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 16,
                left: 16,
                right: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 18),
                  UserTile(
                    userId: widget.venue.id,
                    user: Option.of(widget.venue),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'What should the venue know about you?',
                    ),
                    style: const TextStyle(
                      letterSpacing: 0,
                    ),
                    maxLength: 512,
                    minLines: 6,
                    initialValue: _note,
                    validator: (value) =>
                        value!.isEmpty ? 'message cannot be empty' : null,
                    onChanged: (input) {
                      setState(() {
                        _note = input;
                      });
                    },
                  ),
                  const SocialFollowingMenu(),
                  const SizedBox(height: 12),
                  const PastBookingsSlider(),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CupertinoButton.filled(
                          onPressed: () {
                            database.contactVenue(
                              currentUser: currentUser,
                              lastestBookings: _latestBookings,
                              venue: _venue,
                              note: _note,
                              bookingEmail: _bookingEmail,
                            );
                          },
                          borderRadius: BorderRadius.circular(15),
                          child: const Text(
                            'Send Request',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CupertinoButton(
                          onPressed: () => context.pop(),
                          child: const Text(
                            'cancel',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
