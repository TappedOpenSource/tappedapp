import 'package:flutter/material.dart';

class TappedTextField extends StatefulWidget {
  const TappedTextField({
    required this.title,
    this.initialValue,
    this.onChange,
    this.examples = const [],
    super.key,
  });

  final String title;
  final String? initialValue;
  final void Function(String)? onChange;
  final List<String> examples;

  @override
  State<TappedTextField> createState() => _TappedTextFieldState();
}

class _TappedTextFieldState extends State<TappedTextField> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget exampleChip({
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: () {
            _controller.text = text;
            widget.onChange?.call(text);
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              text,
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

  Widget get _buildExamples => Column(
        children: [
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
          Column(
            children: widget.examples
                .map(
                  (e) => exampleChip(
                    text: e,
                  ),
                )
                .toList(),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
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
                controller: _controller,
                decoration: const InputDecoration.collapsed(
                  hintText: 'type here...',
                ),
              ),
            ),
          ),
          if (widget.examples.isNotEmpty) _buildExamples,
        ],
      ),
    );
  }
}
