import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ClaimProfileButton extends StatelessWidget {
  const ClaimProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Row(
        children: [
          Expanded(
            child: CupertinoButton(
              onPressed: () {
                final uri = Uri.parse('https://tappedapp.notion.site/claim-profile-9300a22781ed43dbba7cf53a17586b1d?pvs=4');
                launchUrl(uri);
              },
              color: theme.colorScheme.onSurface.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              child: const Text(
                'claim this profile',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
