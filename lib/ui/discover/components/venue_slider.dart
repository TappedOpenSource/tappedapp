import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/discover/components/venue_card.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class VenueSlider extends StatelessWidget {
  const VenueSlider({
    required this.venues,
    super.key,
  });

  final List<UserModel> venues;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: SizedBox(
        height: 200,
        child: ScrollSnapList(
          onItemFocus: (index) {},
          selectedItemAnchor: SelectedItemAnchor.START,
          itemCount: venues.length,
          itemSize: 150 + (8 * 2),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: VenueCard(venue: venues[index]),
            );
          },
        ),
      ),
    );
  }
}
