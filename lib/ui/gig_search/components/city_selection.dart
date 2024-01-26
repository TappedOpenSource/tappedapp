import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

class CitySelection extends StatelessWidget {
  CitySelection({
    required this.onConfirm,
    required this.initialValue,
    super.key,
  });

  final List<String> initialValue;
  final void Function(List<String?>) onConfirm;

  final cities = [
    'atlanta',
    'richmond',
    'dc',
    'nyc',
    'chicago',
    'detroit',
    'los angeles',
    'san francisco',
  ];
  List<MultiSelectItem<String>> get _items => cities
      .map((city) => MultiSelectItem<String>(city, city))
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
            'Select Cities',
            style: TextStyle(
              color: tappedAccent,
              fontSize: 16,
            ),
          ),
          title: const Text('Genres'),
          items: _items,
          onConfirm: onConfirm.call,
          chipDisplay: MultiSelectChipDisplay(
            items: initialValue
                .map((city) => MultiSelectItem<String>(city, city))
                .toList(),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
