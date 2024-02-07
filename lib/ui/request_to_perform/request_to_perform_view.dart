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
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
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
                  Divider(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'What else should the venue know about you?',
                    ),
                    style: const TextStyle(
                      letterSpacing: 0,
                    ),
                    maxLength: 512,
                    minLines: 8,
                    initialValue: _note,
                    validator: (value) =>
                        value!.isEmpty ? 'message cannot be empty' : null,
                    onChanged: (input) {
                      setState(() {
                        _note = input;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 12),
                                      Text(
                                        currentUser.displayName,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'Socials',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SocialFollowingMenu(
                                        user: currentUser,
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'Booking History',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      PastBookingsSlider(
                                        user: currentUser,
                                      ),
                                      const SizedBox(height: 12),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: const Text('what info are we sending?'),
                      ),
                    ],
                  ),
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
