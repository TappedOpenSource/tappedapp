
import 'package:flutter/material.dart';

class DraggableHeader extends StatelessWidget {
  const DraggableHeader({
    required this.scrollController,
    required this.bottomSheetDraggableAreaHeight,
    super.key,
  });

  static const indicatorHeight = 4.0;
  final ScrollController scrollController;
  final double bottomSheetDraggableAreaHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      controller: scrollController,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(12),
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical:
              bottomSheetDraggableAreaHeight / 2 - indicatorHeight / 2,
            ),
            child: Container(
              height: indicatorHeight,
              width: 72,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                color: theme.colorScheme.onSurface.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
