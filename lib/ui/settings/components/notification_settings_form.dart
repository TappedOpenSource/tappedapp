import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/settings/components/settings_switch.dart';
import 'package:intheloopapp/ui/settings/settings_cubit.dart';

class NotificationSettingsForm extends StatelessWidget {
  const NotificationSettingsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Column(
          children: [
            const SizedBox(height: 10),
            const Row(
              children: [
                Text(
                  'Push Notifications',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SettingsSwitch(
              label: 'New DMs',
              activated: state.pushNotificationsDirectMessages,
              onChanged: (selected) =>
                  context.read<SettingsCubit>().changeDirectMsgPush(
                        selected: selected,
                      ),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Text(
                  'Emails',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SettingsSwitch(
              label: 'New App Releases',
              activated: state.emailNotificationsAppReleases,
              onChanged: (selected) =>
                  context.read<SettingsCubit>().changeAppReleaseEmail(
                        selected: selected,
                      ),
            ),
          ],
        );
      },
    );
  }
}
