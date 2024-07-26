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
                  'push notifications',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SettingsSwitch(
              label: 'new direct messages',
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
                  'emails',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SettingsSwitch(
                label: 'new app releases',
                activated: state.emailNotificationsAppReleases,
                onChanged: (selected) =>
                    context.read<SettingsCubit>().changeAppReleaseEmail(
                          selected: selected,
                        ),),
            SettingsSwitch(
              label: 'new direct messages',
              activated: state.emailNotificationsDirectMessages,
              onChanged: (selected) =>
                  context.read<SettingsCubit>().changeDirectMessagesEmail(
                        selected: selected,
                      ),
            ),
          ],
        );
      },
    );
  }
}
