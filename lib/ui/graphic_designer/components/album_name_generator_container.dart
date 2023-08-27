import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlbumNameGeneratorContainer extends StatelessWidget {
  const AlbumNameGeneratorContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Clipboard.setData(const ClipboardData(text: 'fake album name'));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Copied to Clipboard'),
              ),
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 32,
            ),
            child: Card(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'fake album name',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(
                      Icons.copy,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 32,
            ),
            child: CupertinoButton.filled(
              onPressed: () {},
              child: const Text(
                'generate album name',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
