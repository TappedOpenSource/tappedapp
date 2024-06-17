import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/booking_history/booking_history_cubit.dart';
import 'package:intheloopapp/ui/booking_history/components/booking_bottom_sheet.dart';
import 'package:intheloopapp/ui/booking_history/components/booking_map.dart';
import 'package:intheloopapp/ui/common/tapped_app_bar.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class BookingHistoryView extends StatelessWidget {
  const BookingHistoryView({
    required this.user,
    super.key,
  });

  final UserModel user;

  Widget _buildMapButton(BuildContext context, {
    required String heroTag,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    return FloatingActionButton(
      elevation: 2,
      heroTag: heroTag,
      highlightElevation: 3,
      backgroundColor: theme.colorScheme.surface,
      mini: true,
      onPressed: onPressed,
      splashColor: Colors.transparent,
      child: Icon(
        icon,
        color: theme.colorScheme.onBackground,
      ),
    );
  }

  Widget _buildControlButtons(BuildContext context,
      MapController mapController,) {
    return BlocBuilder<BookingHistoryCubit, BookingHistoryState>(
      builder: (context, state) {
        return Positioned(
          bottom: 110 + 10,
          right: 10,
          child: Column(
            children: [
              _buildMapButton(
                context,
                icon: state.showFlierMarkers ? Icons.image_not_supported : Icons.image,
                heroTag: 'toggle-flier-markers',
                onPressed: () {
                  FirebaseAnalytics.instance.logEvent(
                    name: 'toggle_flier_markers',
                  );

                  context.read<BookingHistoryCubit>().toggleFlierMarkers();
                },
              ),
              if (kDebugMode)
                _buildMapButton(
                  context,
                  icon: Icons.add,
                  onPressed: () {
                    mapController.move(
                      mapController.camera.center,
                      mapController.camera.zoom + 1,
                    );
                  },
                  heroTag: 'zoom-in',
                ),
              if (kDebugMode)
                _buildMapButton(
                  context,
                  icon: Icons.remove,
                  onPressed: () {
                    mapController.move(
                      mapController.camera.center,
                      mapController.camera.zoom - 1,
                    );
                  },
                  heroTag: 'zoom-out',
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapController = MapController();
    return BlocProvider(
      create: (context) =>
      BookingHistoryCubit(
        database: context.database,
        userId: user.id,
      )
        ..initBookings(),
      child: Scaffold(
        appBar: const TappedAppBar(
          title: 'bookings',
        ),
        extendBodyBehindAppBar: true,
        body: LayoutBuilder(
          builder: (context, contraints) {
            return Stack(
              children: [
                BookingMap(mapController: mapController),
                _buildControlButtons(context, mapController),
              ],
            );
          },
        ),
        bottomSheet: BookingBottomSheet(user: user),
      ),
    );
  }
}
