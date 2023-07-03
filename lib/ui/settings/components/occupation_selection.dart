import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/occupation.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class OccupationSelection extends StatelessWidget {
  const OccupationSelection({
    required this.onConfirm,
    required this.initialValue,
    super.key,
  });

  final List<String> initialValue;
  final void Function(List<String?>) onConfirm;

  List<MultiSelectItem<String>> get _items => occupations
      .map((occupation) => MultiSelectItem<String>(occupation, occupation))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 6),
        MultiSelectBottomSheetField<String?>(
          initialChildSize: 0.4,
          listType: MultiSelectListType.CHIP,
          initialValue: initialValue,
          searchable: true,
          buttonText: const Text(
            'Select Occupation',
            style: TextStyle(
              color: tappedAccent,
              fontSize: 16,
            ),
          ),
          title: const Text('Occupations'),
          items: _items,
          onConfirm: onConfirm.call,
          chipDisplay: MultiSelectChipDisplay(
            items: initialValue
                .map(
                  (occupation) => MultiSelectItem<String>(
                    occupation,
                    occupation,
                  ),
                )
                .toList(),
            // onTap: (value) {
            //   if (value != null) {
            //     context.read<SettingsCubit>().removeOccupation(value);
            //   }
            // },
          ),
        ),
        const Divider(),
      ],
    );
  }
}
