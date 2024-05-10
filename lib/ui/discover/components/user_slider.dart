
import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/performer_info.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/user_card.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class UserSlider extends StatelessWidget {
  const UserSlider({
    required this.users,
    this.sort = false,
    this.blur = false,
    this.onTap,
    super.key,
  });

  final List<UserModel> users;
  final bool sort;
  final bool blur;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    if (sort) {
      users.sort((a, b) {
        final categoryA = a.performerInfo.fold(
          () => PerformerCategory.undiscovered,
          (t) => t.category,
        );
        final categoryB = b.performerInfo.fold(
          () => PerformerCategory.undiscovered,
          (t) => t.category,
        );

        return categoryB.index.compareTo(categoryA.index);
      });
    }

    return SizedBox(
      height: 200,
      child: ScrollSnapList(
        onItemFocus: (index) {},
        selectedItemAnchor: SelectedItemAnchor.START,
        itemCount: users.length,
        itemSize: 150 + (8 * 2),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: UserCard(
              blur: blur,
              user: users[index],
              onTap: onTap,
            ),
          );
        },
      ),
    );
  }
}
