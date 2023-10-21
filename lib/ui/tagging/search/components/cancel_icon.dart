import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';

class CancelIcon extends StatefulWidget {
  const CancelIcon({
    required this.focusNode,
    required this.searchController,
    required this.onClear,
    Key? key,
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController searchController;
  final VoidCallback onClear;

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
            widget.onClear();
            context.read<SearchBloc>().add(ClearSearch());
          },
        );
      },
    );
  }
}
