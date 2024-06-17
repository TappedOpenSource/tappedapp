import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/genre.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/settings/components/genre_selection.dart';
import 'package:intheloopapp/utils/premium_builder.dart';

class MapSettings extends StatefulWidget {
  const MapSettings({
    required this.genreFilters,
    required this.onConfirmGenreSelection,
    required this.onCapacityRangeChange,
    this.initialRange,
    this.maxCapacity = 1000,
    super.key,
  });

  final List<Genre> genreFilters;
  final void Function(List<Genre?>) onConfirmGenreSelection;
  final void Function(RangeValues) onCapacityRangeChange;
  final RangeValues? initialRange;

  final int maxCapacity;

  @override
  State<MapSettings> createState() => _MapSettingsState();
}

class _MapSettingsState extends State<MapSettings> {
  late RangeValues capacityRange;

  int get capacityRangeStart => capacityRange.start.round();

  int get capacityRangeEnd => capacityRange.end.round();

  @override
  void initState() {
    capacityRange = widget.initialRange ??
        RangeValues(
          0,
          widget.maxCapacity.toDouble(),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PremiumBuilder(
      builder: (context, isPremium) {
        return Stack(
          children: [
            Container(
              height: 600,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'genres',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  GenreSelection(
                    initialValue: widget.genreFilters,
                    onConfirm: widget.onConfirmGenreSelection,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'capacity',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  Row(
                    children: [
                      Text(capacityRangeStart.toString()),
                      Expanded(
                        child: RangeSlider(
                          values: capacityRange,
                          max: widget.maxCapacity.toDouble(),
                          onChanged: (range) {
                            setState(() {
                              capacityRange = range;
                            });
                            widget.onCapacityRangeChange(range);
                          },
                          activeColor: theme.colorScheme.primary,
                          inactiveColor:
                              theme.colorScheme.onSurface.withOpacity(0.4),
                          divisions: widget.maxCapacity,
                          labels: RangeLabels(
                            capacityRangeStart.toString(),
                            capacityRangeEnd.toString(),
                          ),
                        ),
                      ),
                      Text(
                        capacityRangeEnd == widget.maxCapacity
                            ? '${widget.maxCapacity}+'
                            : capacityRangeEnd.toString(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (!isPremium)
              Container(
                height: 600,
                width: double.infinity,
                color: theme.colorScheme.surface.withOpacity(0.7),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 96,
                    ),
                    const Text(
                      'upgrade to premium to find the perfect venue for you',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        context.push(PaywallPage());
                      },
                      child: const Text(
                        'upgrade',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
