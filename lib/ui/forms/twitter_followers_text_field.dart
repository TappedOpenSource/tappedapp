import 'package:flutter/material.dart';

class TwitterFollowersTextField extends StatelessWidget {
  const TwitterFollowersTextField({
    this.initialValue,
    this.onChanged,
    super.key,
  });

  final int? initialValue;
  final void Function(int)? onChanged;

  @override
  Widget build(BuildContext context) {
    final iVal = initialValue ?? 0;
    return TextFormField(
      initialValue: iVal.toString(),
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.people),
        labelText: 'Twitter Followers',
      ),
      keyboardType: TextInputType.number,
      onChanged: (input) {
        final value = double.tryParse(input) ?? 0;
        final usdValue = value.toInt();

        onChanged?.call(usdValue);
      },
    );
  }
}
