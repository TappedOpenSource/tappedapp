import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AnimatedRadialGauge(
            /// The animation duration.
            duration: const Duration(seconds: 1),
            curve: Curves.elasticOut,

            /// Define the radius.
            /// If you omit this value, the parent size will be used, if possible.
            radius: 80,

            /// Gauge value.
            value: category.performerScore.toDouble(),

            /// Optionally, you can configure your gauge, providing additional
            /// styles and transformers.
            axis: GaugeAxis(
              /// Provide the [min] and [max] value for the [value] argument.
              min: 0,
              max: 100,

              /// Render the gauge as a 180-degree arc.
              degrees: 180,

              /// Set the background color and axis thickness.
              style: const GaugeAxisStyle(
                thickness: 20,
                background: Colors.transparent,
                segmentSpacing: 6,
              ),

              /// Define the pointer that will indicate the progress (optional).
              pointer: GaugePointer.needle(
                width: 15,
                height: 60,
                borderRadius: 16,
                color: theme.colorScheme.onSurface,
              ),

              /// Define the progress bar (optional).
              progressBar: const GaugeProgressBar.rounded(
                color: Colors.transparent,
                placement: GaugeProgressPlacement.inside,
              ),

              /// Define axis segments (optional).
              segments: [
                for (final categoryValue in categoryValues)
                  GaugeSegment(
                    from: categoryValue.performerScoreRange.$1.toDouble(),
                    to: categoryValue.performerScoreRange.$2.toDouble(),
                    color: categoryValue == category
                        ? categoryValue.color
                        : categoryValue.color.withOpacity(0.5),
                    cornerRadius: const Radius.circular(5),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: categoryValues.map((e) {
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
                                  : e.color.withOpacity(0.5)
                            ),
                          ),
                          Text(
                            e.description,
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
            }).toList(),
          ),
        ],
      ),
    );
  }
}
