import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/comments/comments_cubit.dart';
import 'package:intheloopapp/ui/comments/components/comments_list.dart';
import 'package:intheloopapp/ui/comments/components/comments_text_field.dart';
import 'package:intheloopapp/ui/loading/loop_loading_view.dart';
import 'package:intheloopapp/ui/loop_container/loop_container.dart';
import 'package:intheloopapp/ui/loop_view/loop_view_cubit.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class LoopView extends StatelessWidget {
  const LoopView({
    required this.loop,
    this.loopUser = const None(),
    super.key,
  });

  final Loop loop;
  final Option<UserModel> loopUser;

  Widget _buildLoopView(
    DatabaseRepository database,
    UserModel currentUser,
    UserModel user,
  ) =>
      BlocProvider<LoopViewCubit>(
        create: (context) => LoopViewCubit(
          databaseRepository: database,
          loop: loop,
          currentUser: currentUser,
          user: user,
        )
          ..initLoopLikes()
          ..checkVerified(),
        child: BlocBuilder<LoopViewCubit, LoopViewState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(
                title: const Text('Loop'),
              ),
              body: BlocProvider(
                create: (context) => CommentsCubit(
                  currentUser: currentUser,
                  databaseRepository: database,
                  loop: loop,
                  loopViewCubit: context.read<LoopViewCubit>(),
                )..initComments(),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: LoopContainer(
                        loop: loop,
                        commentStream: context
                            .read<LoopViewCubit>()
                            .commentController
                            .stream,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 8),
                    ),
                    const SliverToBoxAdapter(
                      child: CommentsTextField(),
                    ),
                    const CommentsList(),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 50),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    final database = RepositoryProvider.of<DatabaseRepository>(context);
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return switch (loopUser) {
          None() => FutureBuilder<Option<UserModel>>(
              future: database.getUserById(loop.userId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const LoopLoadingView();
                }

                final user = snapshot.data;
                return switch (user) {
                  null => const LoopLoadingView(),
                  None() => const LoopLoadingView(),
                  Some(:final value) => _buildLoopView(
                      database,
                      currentUser,
                      value,
                    ),
                };
              },
            ),
          Some(:final value) => _buildLoopView(
              database,
              currentUser,
              value,
            ),
        };
      },
    );
  }
}
