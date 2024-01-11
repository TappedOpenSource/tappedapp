import 'package:feedback/feedback.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class FeedbackButton extends StatelessWidget {
  const FeedbackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final database = context.database;
    final storage = context.storage;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return CupertinoButton(
          onPressed: () {
            BetterFeedback.of(context).show((UserFeedback feedback) async {
              try {
                logger
                    .debug('feedback: ${feedback.text} and ${feedback.extra}');

                final imageUrl = await storage.uploadFeedbackScreenshot(
                  currentUser.id,
                  feedback.screenshot,
                );
                await database.sendFeedback(currentUser.id, feedback, imageUrl);

                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.green,
                    content: Text('feedback sent'),
                  ),
                );
              } catch (error, stackTrace) {
                logger.error(
                  'error sending feedback',
                  error: error,
                  stackTrace: stackTrace,
                );
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                    content: Text('error sending feedback'),
                  ),
                );
              }
            });
          },
          color: theme.colorScheme.onSurface.withOpacity(0.1),
          padding: const EdgeInsets.all(12),
          child: Text(
            'Feedback',
            style: TextStyle(
              fontSize: 17,
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}