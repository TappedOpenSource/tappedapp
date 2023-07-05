import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    super.key,
    this.onSaved,
    this.onChanged,
    this.labelText = 'Password',
  });

  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(
          18,
        ),
        child: TextFormField(
          obscureText: true,
          decoration: InputDecoration.collapsed(
            // prefixIcon: const Icon(Icons.lock),
            // labelText: labelText,
            hintText: labelText,
          ),
          validator: (input) {
            if (input!.trim().length < 8) {
              return 'please enter a valid handle';
            }
          
            return null;
          },
          onChanged: (input) async {
            onChanged?.call(input);
          },
        ),
      ),
    );
  }
}
