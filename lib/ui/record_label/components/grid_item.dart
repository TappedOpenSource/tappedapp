import 'package:flutter/material.dart';

class GridItem extends StatelessWidget {
  const GridItem({
    required this.title,
    required this.icon,
    this.disabled = false,
    this.onTap,
    super.key,
  });

  final String title;
  final IconData icon;
  final bool disabled;
  final void Function()? onTap;

  Widget buildGridItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        child: InkWell(
          onTap: disabled ? null : onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return switch (disabled) {
      false => buildGridItem(context),
      true => Stack(
          children: [
            Positioned.fill(
              child: buildGridItem(context),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            const Positioned.fill(
              child: Center(
                child: Icon(
                  Icons.lock,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
    };
  }
}
