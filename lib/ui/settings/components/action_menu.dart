import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/domains/subscription_bloc/subscription_bloc.dart';
import 'package:intheloopapp/ui/settings/components/settings_button.dart';
import 'package:intheloopapp/ui/settings/settings_cubit.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/premium_builder.dart';
import 'package:url_launcher/url_launcher.dart';

class ActionMenu extends StatelessWidget {
  const ActionMenu({super.key});

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    final subscriptions = context.subscriptions;
    final theme = Theme.of(context);
    final nav = context.nav;
    final authBloc = context.authentication;
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Column(
          children: [
            const Divider(),
            PremiumBuilder(
              builder: (context, isPremium) {
                if (!isPremium) {
                  return SettingsButton(
                    icon: const Icon(FontAwesomeIcons.crown),
                    label: 'go premium',
                    onTap: () {
                      context.push(PaywallPage());
                    },
                  );
                }
                return SettingsButton(
                  icon: const Icon(FontAwesomeIcons.crown),
                  label: 'manage subscription',
                  onTap: () {
                    logger.debug('manage subscription');
                    return switch (subscriptions.state) {
                      Initialized(:final customerInfo) =>
                        customerInfo.managementURL != null
                            ? launchUrl(
                                Uri.parse(
                                  customerInfo.managementURL!,
                                ),
                              )
                            : context.push(PaywallPage()),
                      _ => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            backgroundColor: Colors.red,
                            content: const Text(
                              'subscription is uninitialized',
                            ),
                          ),
                        ),
                    };
                  },
                );
              },
            ),
            const Divider(),
            SettingsButton(
              icon: const Icon(Icons.verified),
              label: 'get verified',
              onTap: () => showModalBottomSheet(
                context: context,
                showDragHandle: true,
                builder: (context) {
                  return SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.verified,
                            color: theme.colorScheme.primary,
                            size: 96,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.lightbulb,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'to get verified, post a screenshot of your profile to your instagram story and tag us @tappedai',
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            SettingsButton(
              icon: const Icon(FontAwesomeIcons.comments),
              label: 'Give us Feedback',
              onTap: () => launchUrl(
                Uri(
                  scheme: 'mailto',
                  path: 'support@tapped.ai',
                  query: encodeQueryParameters(<String, String>{
                    'subject': 'Tapped User Feedback',
                  }),
                ),
              ),
            ),
            const Divider(),
            SettingsButton(
              icon: const Icon(
                FontAwesomeIcons.instagram,
                size: 20,
              ),
              label: 'Follow us on Instagram',
              onTap: () => launchUrl(
                Uri(
                  scheme: 'https',
                  path: 'instagram.com/tappedai',
                ),
              ),
            ),
            const Divider(),
            SettingsButton(
              icon: const Icon(
                FontAwesomeIcons.userSecret,
                size: 20,
              ),
              label: 'Privacy Policy',
              onTap: () => launchUrl(
                Uri(
                  scheme: 'https',
                  path: 'app.tapped.ai/privacy',
                ),
              ),
            ),
            const Divider(),
            SettingsButton(
              icon: const Icon(
                FontAwesomeIcons.fileContract,
                size: 20,
              ),
              label: 'Terms of Service',
              onTap: () => launchUrl(
                Uri(
                  scheme: 'https',
                  path:
                      'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/',
                ),
              ),
            ),
            const Divider(),
            SettingsButton(
              icon: const Icon(
                FontAwesomeIcons.rightFromBracket,
                size: 20,
              ),
              label: 'Sign Out',
              onTap: () => showDialog<AlertDialog>(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 5,
                  title: const Text('Sign Out'),
                  content: const Text(
                    "Are you sure you'd like to sign out?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: Navigator.of(context).pop,
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      child: const Text('Continue'),
                      onPressed: () {
                        try {
                          Navigator.of(context).pop();
                          nav.popUntilHome();
                          authBloc.add(LoggedOut());
                        } catch (e, s) {
                          logger.e(
                            'error signing out',
                            error: e,
                            stackTrace: s,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
          ],
        );
      },
    );
  }
}
