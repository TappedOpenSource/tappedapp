import 'package:flutter/material.dart';

class ArtistNameTextField extends StatelessWidget {
  const ArtistNameTextField({
    super.key,
    this.onSaved,
    this.onChanged,
    this.initialValue,
  });

  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(
          18,
        ),
        child: TextFormField(
          initialValue: initialValue,
          decoration: const InputDecoration.collapsed(
            hintText: 'performer name (e.g. Doja Cat)',
          ),
          validator: (input) {
            if (input!.trim().isEmpty) {
              return 'please enter a valid name';
            }

            return null;
          },
          onSaved: (input) async {
            if (input == null || input.isEmpty) return;

            input = input.trim();
            onSaved?.call(input);
          },
          onChanged: (input) async {
            if (input.isEmpty) return;

            input = input.trim();
            onChanged?.call(input);
          },
        ),
      ),
    );
  }
}
