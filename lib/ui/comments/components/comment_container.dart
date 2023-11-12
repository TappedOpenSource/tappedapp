import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/comment.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/user_avatar.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/linkify.dart';
import 'package:skeletons/skeletons.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentContainer extends StatefulWidget {
  const CommentContainer({
    required this.comment,
    super.key,
    this.maxLines,
    this.previewLoop = const None(),
  });
  final Comment comment;
  final int? maxLines;
  final Option<Loop> previewLoop;

  @override
  State<CommentContainer> createState() => _CommentContainerState();
}

class _CommentContainerState extends State<CommentContainer> {
  bool _isLiked = false;
  int _likeCount = 0;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.comment.likeCount;
    initLiked().then((value) => _isLiked = value).whenComplete(() {
      setState(() {});
    });
  }

  Future<bool> initLiked() async {
    try {
      final databaseRepository =
          RepositoryProvider.of<DatabaseRepository>(context);
      final onboardingBloc = RepositoryProvider.of<OnboardingBloc>(context);

      if (onboardingBloc.state is! Onboarded) {
        return false;
      }

      final currentUserId = (onboardingBloc.state as Onboarded).currentUser.id;

      final isLiked = await databaseRepository.isCommentLiked(
        currentUserId,
        widget.comment,
      );

      return isLiked;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);
    //final loop =  databaseRepository.getLoopById(widget.comment.rootId);
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return FutureBuilder<Option<UserModel>>(
          future: databaseRepository.getUserById(widget.comment.userId),
          builder: (context, snapshot) {
            final user = snapshot.data;

            return switch (user) {
              null => SkeletonListTile(),
              None() => SkeletonListTile(),
              Some(:final value) => FutureBuilder<bool>(
                  future: databaseRepository.isVerified(widget.comment.userId),
                  builder: (context, snapshot) {
                    final isVerified = snapshot.data ?? false;

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: ListTile(
                        onTap: () {
                          return switch (widget.previewLoop) {
                            None() => context.push(
                                ProfilePage(
                                  userId: value.id,
                                  user: user,
                                ),
                              ),
                            Some(:final value) => context.push(
                                LoopPage(
                                  loop: value,
                                  loopUser: user,
                                ),
                              ),
                          };
                        },
                        leading: UserAvatar(
                          radius: 20,
                          pushUser: user,
                          imageUrl: value.profilePicture,
                          verified: isVerified,
                        ),
                        trailing: TextButton.icon(
                          onPressed: () {
                            if (_isLiked) {
                              databaseRepository.unlikeComment(
                                currentUser.id,
                                widget.comment,
                              );
                            } else {
                              databaseRepository.likeComment(
                                currentUser.id,
                                widget.comment,
                              );
                            }

                            setState(() {
                              if (_isLiked) {
                                _likeCount--;
                              } else {
                                _likeCount++;
                              }

                              _isLiked = !_isLiked;
                            });
                          },
                          label: Text(
                            _likeCount.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          icon: _isLiked
                              ? const Icon(
                                  CupertinoIcons.heart_fill,
                                  size: 14,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  CupertinoIcons.heart,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                        ),
                        title: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                            ),
                            children: [
                              TextSpan(
                                text: value.displayName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const WidgetSpan(
                                child: SizedBox(
                                  width: 8,
                                ),
                              ),
                              TextSpan(
                                text: timeago.format(
                                  widget.comment.timestamp.toDate(),
                                  locale: 'en_short',
                                ),
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Linkify(
                          text: widget.comment.content,
                          maxLines: widget.maxLines,
                        ),
                      ),
                    );
                  },
                ),
            };
          },
        );
      },
    );
  }
}
