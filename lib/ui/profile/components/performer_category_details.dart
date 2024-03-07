import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/performer_info.dart';

class PerformerCategoryDetails extends StatelessWidget {
  const PerformerCategoryDetails({
    required this.category,
    super.key,
  });

  final PerformerCategory category;

  @override
  Widget build(BuildContext context) {
    const categoryValues = PerformerCategory.values;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...categoryValues.map((e) {
            final isSelected = e == category;
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isSelected ? e.color : e.color.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.formattedName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? e.color
                                  : e.color.withOpacity(0.5),),
                        ),
                        Text(
                          e.description.toLowerCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: theme.colorScheme.onSurface,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.lightbulb,
                color: Colors.amber,
              ),
              const SizedBox(width: 8),
              Text(
                'you can improve your score by getting more gigs!',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
