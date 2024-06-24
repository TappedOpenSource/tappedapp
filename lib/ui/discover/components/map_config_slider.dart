import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/discover/discover_cubit.dart';
import 'package:intheloopapp/utils/custom_claims_builder.dart';

class MapConfigSlider extends StatefulWidget {
  const MapConfigSlider({
    required this.initialOverlay,
    required this.onChange,
    super.key,
  });

  final MapOverlay initialOverlay;
  final void Function(MapOverlay overlay, bool premiumOnly) onChange;

  @override
  State<MapConfigSlider> createState() => _MapConfigSliderState();
}

class _MapConfigSliderState extends State<MapConfigSlider> {
  late MapOverlay _currentOverlay;

  @override
  void initState() {
    super.initState();
    _currentOverlay = widget.initialOverlay;
  }

  Widget _buildMapOverlayButton(
    BuildContext context, {
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
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _currentOverlay = overlay;
              });
              widget.onChange(overlay, premiumOnly);
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        children: [
          _buildMapOverlayButton(
            context,
            currentOverlay: _currentOverlay,
            overlay: MapOverlay.venues,
            label: 'venues',
            image: const AssetImage(
              'assets/layers/venue_markers.png',
            ),
          ),
          // _buildMapOverlayButton(
          //   context,
          //   currentOverlay: _currentOverlay,
          //   overlay: MapOverlay.userBookings,
          //   label: 'my bookings',
          //   image: const AssetImage(
          //     'assets/layers/my_bookings_polygon.png',
          //   ),
          // ),
          // _buildMapOverlayButton(
          //   context,
          //   currentOverlay: _currentOverlay,
          //   overlay: MapOverlay.bookings,
          //   label: 'bookings',
          //   image: const AssetImage(
          //     'assets/layers/booking_heatmap.png',
          //   ),
          //   premiumOnly: true,
          // ),
          _buildMapOverlayButton(
            context,
            currentOverlay: _currentOverlay,
            overlay: MapOverlay.opportunities,
            label: 'opportunities',
            image: const AssetImage(
              'assets/layers/op_heatmap.png',
            ),
            premiumOnly: true,
          ),
        ],
      ),
    );
  }
}
