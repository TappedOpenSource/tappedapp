import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/ui/settings/components/connect_bank_button.dart';
import 'package:intheloopapp/ui/settings/components/services_list.dart';
import 'package:intheloopapp/ui/settings/settings_cubit.dart';
import 'package:intheloopapp/ui/themes.dart';

class PaymentSettingsForm extends StatelessWidget {
  const PaymentSettingsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Column(
          children: [
            const ConnectBankButton(),
            if (state.status.isInProgress)
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(tappedAccent),
              )
            else
              const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
