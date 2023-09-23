import 'package:flutter/material.dart';

class AestheticFormField extends StatelessWidget {
  const AestheticFormField({
    this.initialValue,
    this.onChange,
    super.key,
  });

  final String? initialValue;
  final void Function(String)? onChange;

  Widget aestheticButton({
    required String aesthetic,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: () => onChange?.call(aesthetic),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              aesthetic,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'what is the aesthetic?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(
                18,
              ),
              child: TextFormField(
                initialValue: initialValue,
                decoration: const InputDecoration.collapsed(
                  hintText: 'type here...',
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Divider(
                  height: 0,
                  thickness: 0.5,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                'or',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Divider(
                  height: 0,
                  thickness: 0.5,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  aestheticButton(aesthetic: 'aesthetic 1'),
                  aestheticButton(aesthetic: 'aesthetic 2'),
                  aestheticButton(aesthetic: 'aesthetic 3'),
                ],
              ),
              Column(
                children: [
                  aestheticButton(aesthetic: 'aesthetic 4'),
                  aestheticButton(aesthetic: 'aesthetic 5'),
                  aestheticButton(aesthetic: 'aesthetic 6'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
