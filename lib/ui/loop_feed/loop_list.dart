import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/common/easter_egg_placeholder.dart';
import 'package:intheloopapp/ui/loading/list_loading_view.dart';
import 'package:intheloopapp/ui/loop_container/loop_container.dart';
import 'package:intheloopapp/ui/loop_feed/loop_feed_cubit.dart';

class LoopList extends StatefulWidget {
  const LoopList({
    required this.feedKey,
    required this.scrollController,
    required this.headerSliver,
    super.key,
  });

  final String feedKey;
  final ScrollController scrollController;
  final Widget? headerSliver;

  @override
  State<LoopList> createState() => _LoopListState();
}

class _LoopListState extends State<LoopList> {
  late LoopFeedCubit _loopFeedCubit;
  Timer? _debounce;
  ScrollController get _scrollController => widget.scrollController;

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScroll() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      if (_isBottom) _loopFeedCubit.fetchMoreLoops();
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loopFeedCubit = context.read<LoopFeedCubit>();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoopFeedCubit, LoopFeedState>(
      builder: (context, state) {
        switch (state.status) {
          case LoopFeedStatus.initial:
            return const ListLoadingView();
          case LoopFeedStatus.success:
            if (state.loops.isEmpty) {
              return const Center(
                child: EasterEggPlaceholder(
                  text: 'No Loops',
                  color: Colors.white,
                ),
              );
            }

            return RefreshIndicator(
              displacement: 20,
              onRefresh: () async {
                await Future.wait([
                  context.read<LoopFeedCubit>().initLoops(),
                  HapticFeedback.mediumImpact(),
                ]);
              },
              child: CustomScrollView(
                controller: widget.scrollController,
                physics: const ClampingScrollPhysics(),
                key: PageStorageKey<String>(widget.feedKey),
                slivers: [
                  if (widget.headerSliver != null) widget.headerSliver!,
                  SliverPadding(
                    padding: const EdgeInsets.all(8),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return LoopContainer(
                            loop: state.loops[index],
                          );
                        },
                        childCount: state.loops.length,
                      ),
                    ),
                  ),
                ],
              ),
            );

          case LoopFeedStatus.failure:
            return const Center(
              child: EasterEggPlaceholder(
                text: 'Error Fetching Loops :(',
                color: Colors.white,
              ),
            );
        }
      },
    );
  }
}