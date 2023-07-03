import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intheloopapp/ui/loading/logo_wave.dart';
import 'package:rive/rive.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: const Align(
        alignment: Alignment(0, -1 / 4),
        child: Center(
          child: LogoWave(),
        ),
      ),
    );
  }
}
