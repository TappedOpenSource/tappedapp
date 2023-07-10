import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/stream_repository.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';

class MessageButton extends StatelessWidget {
  const MessageButton({super.key});

  @override
  Widget build(BuildContext context) {
    final stream = context.read<StreamRepository>();
    final nav = context.read<NavigationBloc>();
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return IconButton.filled(
          onPressed: () async {
            final channel = await stream.createSimpleChat(state.visitedUser.id);
            nav.push(StreamChannelPage(channel: channel));
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.white.withOpacity(0.1),
            ),
            shape: MaterialStateProperty.all(
              const CircleBorder(),
            ),
          ),
          icon: const Icon(
            Icons.mail_outline,
            color: Colors.white,
          ),
        );
      },
    );
  }
}
