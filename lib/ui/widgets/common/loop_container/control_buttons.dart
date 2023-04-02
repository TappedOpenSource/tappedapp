import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/dynamic_link_repository.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_container_cubit.dart';
import 'package:share_plus/share_plus.dart';

class ControlButtons extends StatelessWidget {
  const ControlButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamic = context.read<DynamicLinkRepository>();
    return BlocBuilder<LoopContainerCubit, LoopContainerState>(
      builder: (context, state) {
        return Row(
          children: [
            GestureDetector(
              onTap: () => context.read<LoopContainerCubit>().toggleLoopLike(),
              child: state.isLiked
                  ? const Icon(
                      CupertinoIcons.heart_fill,
                      size: 18,
                      color: Colors.red,
                    )
                  : const Icon(
                      CupertinoIcons.heart,
                      size: 18,
                      color: Color(0xFF757575),
                    ),
            ),
            const SizedBox(width: 6),
            Text(
              '${state.likeCount}',
              style: TextStyle(
                color: state.isLiked ? Colors.red : const Color(0xFF757575),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => context.read<NavigationBloc>().add(
                    PushLoop(
                      state.loop,
                      showComments: true,
                      autoPlay: false,
                    ),
                  ),
              child: const Icon(
                CupertinoIcons.bubble_middle_bottom,
                size: 18,
                color: Color(0xFF757575),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '${state.commentCount}',
              style: const TextStyle(
                color: Color(0xFF757575),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () async {
                await context.read<LoopContainerCubit>().incrementShares();

                final link = await dynamic.getShareLoopDynamicLink(state.loop);

                await Share.share(
                  'Check out this loop on Tapped $link',
                );
              },
              child: const Icon(
                CupertinoIcons.share,
                size: 18,
                color: Color(0xFF757575),
              ),
            ),
          ],
        );
      },
    );
  }
}