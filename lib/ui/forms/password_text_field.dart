import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    this.onSaved,
    this.onChanged,
    this.labelText = 'password',
  });

  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final String labelText;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(
          18,
        ),
        child: Row(
          children: [
          Expanded(
              child: TextFormField(
                obscureText: _hidePassword,
                enableSuggestions: false,
                decoration: InputDecoration.collapsed(
                  // prefixIcon: const Icon(Icons.lock),
                  // labelText: labelText,
                  hintText: widget.labelText,
                ),
                validator: (input) {
                  if (input!.trim().length < 8) {
                    return 'please enter a valid handle';
                  }

                  return null;
                },
                onChanged: (input) {
                  widget.onChanged?.call(input);
                },
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _hidePassword = !_hidePassword),
              child: Icon(
                  _hidePassword ? Icons.visibility : Icons.visibility_off,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
