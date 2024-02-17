import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/discover/discover_cubit.dart';
import 'package:intheloopapp/utils/custom_claims_builder.dart';

class MapConfigSlider extends StatelessWidget {
  const MapConfigSlider({super.key});

  Widget _buildMapOverlayButton(BuildContext context, {
    required MapOverlay currentOverlay,
    required MapOverlay overlay,
    required String label,
    required ImageProvider image,
    bool premiumOnly = false,
  }) {
    final theme = Theme.of(context);
    final isSelected = currentOverlay == overlay;
    return CustomClaimsBuilder(
      builder: (context, claims) {
        return InkWell(
          onTap: () {
            if (premiumOnly && !claims.contains(CustomClaim.premium)) {
              context.push(PaywallPage());
              return;
            }

            context.read<DiscoverCubit>().onMapOverlayChange(
              overlay,
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 75,
                width: 75,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: image,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurface.withOpacity(0.3),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoverCubit, DiscoverState>(
      builder: (context, state) {
        return SizedBox(
          height: 150,
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceEvenly,
            children: [
              _buildMapOverlayButton(
                context,
                currentOverlay: state.mapOverlay,
                overlay: MapOverlay.venues,
                label: 'Venues',
                image: AssetImage(
                  'assets/layers/venue_markers.png',
                ) as ImageProvider,
              ),
              _buildMapOverlayButton(
                context,
                currentOverlay: state.mapOverlay,
                overlay: MapOverlay.bookings,
                label: 'Bookings',
                image: AssetImage(
                  'assets/layers/booking_heatmap.png',
                ) as ImageProvider,
              ),
              _buildMapOverlayButton(
                context,
                currentOverlay: state.mapOverlay,
                overlay: MapOverlay.opportunities,
                label: 'Opportunities',
                image: AssetImage(
                  'assets/layers/op_heatmap.png',
                ) as ImageProvider,
              ),
            ],
          ),
        );
      },
    );
  }
}