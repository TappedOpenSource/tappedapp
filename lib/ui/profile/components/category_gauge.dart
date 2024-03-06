import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:intheloopapp/domains/models/performer_info.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';

class CategoryGauge extends StatelessWidget {
  const CategoryGauge({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const categoryValues = PerformerCategory.values;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final category = state.visitedUser.performerInfo.map((t) => t.category);
        return switch (category) {
          None() => const SizedBox.shrink(),
          Some(:final value) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AnimatedRadialGauge(
                        /// The animation duration.
                        duration: const Duration(seconds: 1),
                        curve: Curves.elasticOut,

                        /// Define the radius.
                        /// If you omit this value, the parent size will be used, if possible.
                        radius: 100,

                        /// Gauge value.
                        value: value.performerScore.toDouble(),

                        /// Optionally, you can configure your gauge, providing additional
                        /// styles and transformers.
                        axis: GaugeAxis(
                          /// Provide the [min] and [max] value for the [value] argument.
                          min: 0,
                          max: 100,

                          /// Render the gauge as a 180-degree arc.
                          degrees: 180,

                          /// Set the background color and axis thickness.
                          style: GaugeAxisStyle(
                            thickness: 20,
                            background: Colors.transparent,
                            segmentSpacing: 6,
                          ),

                          /// Define the pointer that will indicate the progress (optional).
                          pointer: GaugePointer.needle(
                            width: 20,
                            height: 80,
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
                                from:
                                    categoryValue.performerScoreRange.$1.toDouble(),
                                to: categoryValue.performerScoreRange.$2.toDouble(),
                                color: categoryValue == value
                                    ? categoryValue.color
                                    : categoryValue.color.withOpacity(0.5),
                                cornerRadius: Radius.circular(5),
                              ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: categoryValues.map((e) {
                          final isSelected = e == value;

                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: 8,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? e.color
                                        : e.color.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  e.formattedName,
                                  style: TextStyle(
                                    color: isSelected
                                        ? e.color
                                        : e.color.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList()
                      ),
                    ],
                  ),
                ),
              ),
            ),
        };
      },
    );
  }
}
