import 'package:flutter/material.dart';

class TappedForm extends StatefulWidget {
  const TappedForm({
    required this.questions,
    this.onNext,
    this.onPrevious,
    this.onSubmit,
    super.key,
  });

  final List<(Widget, bool Function())> questions;
  final void Function()? onNext;
  final void Function()? onPrevious;
  final void Function()? onSubmit;

  @override
  State<TappedForm> createState() => _TappedFormState();
}

class _TappedFormState extends State<TappedForm> {
  int _index = 0;
  Widget get _currQuestion => widget.questions[_index].$1;
  bool Function() get _currValidator => widget.questions[_index].$2;
  bool get _isValid => _currValidator();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numQuestions = widget.questions.length;

    if (widget.questions.isEmpty) {
      return const Center(
        child: Text('No questions'),
      );
    }

    const segmentPadding = 4;
    final segmentWidth =
        MediaQuery.of(context).size.width / numQuestions - (segmentPadding * 2);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widget.questions.map((e) {
                return SizedBox(
                  width: segmentWidth,
                  height: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.questions.indexOf(e) <= _index
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primary.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }).toList(),
            ),
            Expanded(
              child: Center(
                child: _currQuestion,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_index != 0)
                  FilledButton(
                    onPressed: () {
                      setState(() {
                        _index--;
                      });
                      widget.onPrevious?.call();
                    },
                    child: const Text(
                      'back',
                    ),
                  )
                else
                  const SizedBox.shrink(),
                if (_index != numQuestions - 1 && _isValid)
                  FilledButton(
                    onPressed: () {
                      setState(() {
                        _index++;
                      });
                      widget.onNext?.call();
                    },
                    child: const Text(
                      'next',
                    ),
                  ),
                if (_index == numQuestions - 1 && _isValid)
                  FilledButton(
                    onPressed: widget.onSubmit?.call,
                    child: const Text(
                      'submit',
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
