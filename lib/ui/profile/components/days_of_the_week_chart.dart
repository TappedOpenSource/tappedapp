import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/utils/normalize.dart';

class DaysOfTheWeekChart extends StatelessWidget {
  const DaysOfTheWeekChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final daysOfTheWeek = state.visitedUser.venueInfo.map(
          (t) => t.bookingsByDayOfWeek,
        );
        final isVenue = state.visitedUser.venueInfo.isSome();
        if (!isVenue) return const SizedBox.shrink();

        final empty = daysOfTheWeek.fold(
          () => true,
          (value) => value.every((element) => element == 0),
        );

        if (empty) return const SizedBox.shrink();

        final groupedData = daysOfTheWeek.map(
          (d) => normalize(d).asMap().entries.map<BarChartGroupData>((e) {
            return makeGroupData(e.key, e.value);
          }).toList(),
        );

        return switch (groupedData) {
          None() => const SizedBox.shrink(),
          Some(:final value) => Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 20,
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const Text(
                              'when are the shows',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: BarChart(
                                  mainBarData(value),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                          ],
                        ),
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

  BarChartGroupData makeGroupData(
    int x,
    double y,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.blue,
          width: 22,
          borderSide: const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 1,
            color: Colors.white.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  BarChartData mainBarData(List<BarChartGroupData> data) {
    return BarChartData(
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(),
        topTitles: const AxisTitles(),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: data,
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('m', style: style);
        break;
      case 1:
        text = const Text('t', style: style);
        break;
      case 2:
        text = const Text('w', style: style);
        break;
      case 3:
        text = const Text('t', style: style);
        break;
      case 4:
        text = const Text('f', style: style);
        break;
      case 5:
        text = const Text('s', style: style);
        break;
      case 6:
        text = const Text('s', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }
}
