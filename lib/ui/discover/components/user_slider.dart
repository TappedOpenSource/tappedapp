import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/user_card.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class UserSlider extends StatelessWidget {
  const UserSlider({
    required this.users,
    super.key,
  });

  final List<UserModel> users;

  @override
  Widget build(BuildContext context) {
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
            child: UserCard(user: users[index]),
          );
        },
      ),
    );
  }
}
