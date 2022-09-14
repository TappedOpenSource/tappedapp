import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/send_badge/send_badge_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/forms/username_text_field.dart';
import 'package:intheloopapp/ui/widgets/send_badge_view/badge_image_input.dart';
import 'package:intheloopapp/ui/widgets/send_badge_view/badge_receiver_text_field.dart';

class SendBadgeView extends StatelessWidget {
  const SendBadgeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthenticationBloc, AuthenticationState, Authenticated>(
      selector: (state) => state as Authenticated,
      builder: (context, state) {
        UserModel currentUser = state.currentUser;
        return BlocProvider(
          create: (context) => SendBadgeCubit(
            currentUser: currentUser,
            navigationBloc: context.read<NavigationBloc>(),
            databaseRepository: context.read<DatabaseRepository>(),
            storageRepository: context.read<StorageRepository>(),
          ),
          child: BlocBuilder<SendBadgeCubit, SendBadgeState>(
            builder: (context, state) {
              return Scaffold(
                backgroundColor: Theme.of(context).backgroundColor,
                appBar: AppBar(
                  title: Text('Send Badge'),
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Form(
                    key: state.formKey,
                    child: ListView(
                      children: [
                        SizedBox(height: 50),
                        BadgeImageInput(),
                        SizedBox(height: 50),
                        BadgeReceiverTextField(
                          onChanged: (input) => context
                              .read<SendBadgeCubit>()
                              .changeReceiverUsername(input),
                          initialValue: '',
                        ),
                        SizedBox(height: 50),
                        MaterialButton(
                          color: tappedAccent,
                          onPressed: context.read<SendBadgeCubit>().sendBadge,
                          child: Text('Send'),
                        ),
                        state.status.isSubmissionInProgress
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(tappedAccent),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}