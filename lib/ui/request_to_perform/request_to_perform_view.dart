import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/user_tile.dart';

class RequestToPerformView extends StatelessWidget {
  const RequestToPerformView({
    required this.bookingEmail,
    required this.venue,
    super.key,
  });

  final String bookingEmail;
  final UserModel venue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              UserTile(
                userId: venue.id,
                user: Option.of(venue),
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
                maxLength: 1024,
                minLines: 12,
                initialValue: '',
                validator: (value) =>
                    value!.isEmpty ? 'message cannot be empty' : null,
                onChanged: (input) {},
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CupertinoButton.filled(
                      onPressed: () {},
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
  }
}
