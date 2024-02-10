import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class CancelIcon extends StatefulWidget {
  const CancelIcon({
    required this.focusNode,
    required this.searchController,
    this.onTap,
    super.key,
  });

  final FocusNode focusNode;
  final TextEditingController searchController;
  final void Function()? onTap;

  @override
  State<CancelIcon> createState() => _CancelIconState();
}

class _CancelIconState extends State<CancelIcon> {
  bool _isFocused = false;

  void chanceFocus() {
    setState(() {
      _isFocused = !_isFocused;
    });
  }

  @override
  void initState() {
    widget.focusNode.addListener(chanceFocus);
    super.initState();
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(chanceFocus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (!_isFocused && state.searchTerm.isEmpty) {
          return const SizedBox.shrink();
        }

        return IconButton(
          icon: const Icon(CupertinoIcons.xmark),
          // child: const Text('Cancel'),
          onPressed: () {
            widget.focusNode.unfocus();
            widget.searchController.clear();
            context.search.add(ClearSearch());
            widget.onTap?.call();
          },
        );
      },
    );
  }
}
