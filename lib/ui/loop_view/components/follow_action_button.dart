import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/loop_view/components/follow_icon.dart';
import 'package:intheloopapp/ui/loop_view/loop_view_cubit.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class FollowActionButton extends StatelessWidget {
  const FollowActionButton({super.key});

  static const double actionWidgetSize = 60;
  static const double actionIconSize = 35;
  static const double profileImageSize = 50;
  static const double plusIconSize = 20;

  @override
  Widget build(BuildContext context) {
    return CurrentUserBuilder(
      errorWidget: const Center(
        child: Text('An error has occured :/'),
      ),
      builder: (context, currentUser) {
        return BlocBuilder<LoopViewCubit, LoopViewState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: context.read<LoopViewCubit>().toggleFollow,
              child: SizedBox(
                width: 60,
                height: 60,
                child: Stack(
                  children: [
                    Positioned(
                      left: (actionWidgetSize / 2) - (profileImageSize / 2),
                      child: Container(
                        height: profileImageSize,
                        width: profileImageSize,
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(profileImageSize / 2),
                        ),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundImage: state.user.profilePicture == null
                              ? const AssetImage('assets/default_avatar.png')
                                  as ImageProvider
                              : CachedNetworkImageProvider(
                                  state.user.profilePicture!,
                                ),
                        ),
                      ),
                    ),
                    if (currentUser.id == state.user.id)
                      const SizedBox.shrink()
                    else
                      const FollowIcon(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
