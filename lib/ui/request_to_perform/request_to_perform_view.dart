import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/common/social_following_menu.dart';
import 'package:intheloopapp/ui/request_to_perform/components/past_bookings_slider.dart';
import 'package:intheloopapp/ui/user_avatar.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class RequestToPerformView extends StatefulWidget {
  const RequestToPerformView({
    required this.venues,
    super.key,
  });

  final List<UserModel> venues;

  @override
  State<RequestToPerformView> createState() => _RequestToPerformViewState();
}

class _RequestToPerformViewState extends State<RequestToPerformView> {
  String _note = '';

  List<UserModel> get _venues => widget.venues;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildSendButton(
    BuildContext context, {
    required UserModel currentUser,
  }) {
    final database = context.database;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: CupertinoButton.filled(
            onPressed: () {
              if (_note.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      'Message cannot be empty',
                    ),
                  ),
                );
                return;
              }

              EasyLoading.show(status: 'Sending Request');
              Future.wait(
                _venues.map((venue) async {
                  final bookingEmail = venue.venueInfo.flatMap(
                    (info) => info.bookingEmail,
                  );

                  bookingEmail.fold(
                    () => Future<void>.value(),
                    (email) async {
                      await database.contactVenue(
                        currentUser: currentUser,
                        venue: venue,
                        note: _note,
                        bookingEmail: email,
                      );
                    },
                  );
                }),
              ).then((value) {
                EasyLoading.dismiss();
                context.push(RequestToPerformConfirmationPage());
              }).onError((error, stackTrace) {
                EasyLoading.dismiss();
                logger.error(
                  'error sending the request',
                  error: error,
                  stackTrace: stackTrace,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('error sending the request'),
                  ),
                );
              });
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return Scaffold(
          backgroundColor: theme.colorScheme.background,
          appBar: AppBar(),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 50,
                    child: WidgetStack(
                      positions: RestrictedPositions(
                        infoIndent: 5,
                      ),
                      stackedWidgets: _venues
                          .map(
                            (venue) => UserAvatar(
                              pushUser: Option.of(venue),
                              pushId: Option.of(venue.id),
                              imageUrl: venue.profilePicture,
                              radius: 25,
                            ),
                          )
                          .toList(),
                      buildInfoWidget: (surplus) {
                        return CircleAvatar(
                          radius: 25,
                          child: Text(
                            '+$surplus',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
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
                          showModalBottomSheet<void>(
                            context: context,
                            showDragHandle: true,
                            builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                  _buildSendButton(
                    context,
                    currentUser: currentUser,
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
