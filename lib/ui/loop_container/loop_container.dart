import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/audio_repository.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/conditional_parent_widget.dart';
import 'package:intheloopapp/ui/loading/loading_container.dart';
import 'package:intheloopapp/ui/loop_container/attachments.dart';
import 'package:intheloopapp/ui/loop_container/control_buttons.dart';
import 'package:intheloopapp/ui/loop_container/loop_container_cubit.dart';
import 'package:intheloopapp/ui/loop_container/show_interest_button.dart';
import 'package:intheloopapp/ui/loop_container/title_text.dart';
import 'package:intheloopapp/ui/loop_container/user_info.dart';
import 'package:intheloopapp/ui/user_avatar.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/linkify.dart';

class LoopContainer extends StatefulWidget {
  const LoopContainer({
    required this.loop,
    this.commentStream,
    super.key,
  });

  final Loop loop;
  final Stream<int>? commentStream;

  @override
  State<LoopContainer> createState() => _LoopContainerState();
}

class _LoopContainerState extends State<LoopContainer>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Widget _opportunity({
    required Widget child,
  }) =>
      Card(
        child: child,
      );

  Widget _loopContainer({
    required UserModel loopUser,
    required String currentUserId,
  }) =>
      GestureDetector(
        onTap: () => context.push(
          LoopPage(
            loop: widget.loop,
            loopUser: Some(loopUser),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserInfo(
                loopUser: loopUser,
                timestamp: widget.loop.timestamp,
              ),
              TitleText(
                title: widget.loop.title,
              ),
              if (widget.loop.description.isNotEmpty)
                Column(
                  children: [
                    Linkify(
                      text: widget.loop.description,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      linkStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.lightBlue,
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                )
              else
                const SizedBox.shrink(),
              Attachments(
                loop: widget.loop,
                loopUser: loopUser,
              ),
              ShowInterestButton(
                loop: widget.loop,
              ),
              ControlButtons(
                loop: widget.loop,
                currentUserId: currentUserId,
              ),
            ],
          ),
        ),
      );

  Widget _audioLoopContainer({
    required UserModel loopUser,
    required String currentUserId,
  }) =>
      GestureDetector(
        onTap: () => context.push(
          LoopPage(
            loop: widget.loop,
            loopUser: Some(loopUser),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      loopUser.profilePicture!,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserInfo(
                        loopUser: loopUser,
                        timestamp: widget.loop.timestamp,
                      ),
                      TitleText(title: widget.loop.title),
                      const SizedBox(height: 14),
                      if (widget.loop.description.isNotEmpty)
                        Column(
                          children: [
                            Linkify(
                              text: widget.loop.description,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 14),
                          ],
                        )
                      else
                        const SizedBox.shrink(),
                      Attachments(
                        loop: widget.loop,
                        loopUser: loopUser,
                      ),
                    ],
                  ),
                ),
              ),
              ShowInterestButton(
                loop: widget.loop,
              ),
              const SizedBox(height: 8),
              ControlButtons(
                loop: widget.loop,
                currentUserId: currentUserId,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);

    return BlocSelector<OnboardingBloc, OnboardingState, UserModel?>(
      selector: (state) => (state is Onboarded) ? state.currentUser : null,
      builder: (context, currentUser) {
        if (currentUser == null) {
          logger.error('currentUser is null', stackTrace: StackTrace.current);
          return const ListTile(
            leading: UserAvatar(
              radius: 25,
            ),
            title: Text('ERROR'),
            subtitle: Text("something isn't working right :/"),
          );
        }

        return FutureBuilder<(Option<UserModel>, bool)>(
          future: () async {
            final userId = widget.loop.userId;
            final futures = await Future.wait([
              databaseRepository.getUserById(widget.loop.userId),
              if (userId != currentUser.id)
                databaseRepository.isBlocked(
                  blockedUserId: userId,
                  currentUserId: currentUser.id,
                )
              else
                Future.value(false),
            ]);

            return (
              futures[0] as Option<UserModel>,
              futures[1] as bool,
            );
          }(),
          builder: (context, userSnapshot) {
            final data = userSnapshot.data;
            logger.logAnalyticsEvent(
              name: 'loop_view',
              parameters: {
                'loop_id': widget.loop.id,
                'user_id': widget.loop.userId,
              },
            );

            return switch (data) {
              null => const LoadingContainer(),
              (_, true) => const SizedBox.shrink(),
              (None(), false) => const LoadingContainer(),
              (Some(:final value), false) => BlocProvider<LoopContainerCubit>(
                  create: (context) => LoopContainerCubit(
                    databaseRepository: databaseRepository,
                    loop: widget.loop,
                    currentUser: currentUser,
                    audioRepo: context.read<AudioRepository>(),
                    commentStream: widget.commentStream,
                  )..initCommentStream(),
                  child: BlocBuilder<LoopContainerCubit, LoopContainerState>(
                    builder: (context, state) {
                      return ConditionalParentWidget(
                        condition: widget.loop.isOpportunity,
                        conditionalBuilder: _opportunity,
                        child: _loopContainer(
                          loopUser: value,
                          currentUserId: currentUser.id,
                        ),
                      );
                    },
                  ),
                ),
            };
          },
        );
      },
    );
  }
}
