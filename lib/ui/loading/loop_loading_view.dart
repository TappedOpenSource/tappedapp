import 'package:flutter/material.dart';
import 'package:skeleton_animation/skeleton_animation.dart';

class LoopLoadingView extends StatelessWidget {
  const LoopLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            Container(
              padding: const EdgeInsets.all(25),
              alignment: FractionalOffset.bottomLeft,
              margin: const EdgeInsets.only(bottom: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    children: [
                      Skeleton(
                        height: 30,
                        width: 150,
                        style: SkeletonStyle.text,
                        textColor: Colors.grey.shade500,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Skeleton(
                        height: 30,
                        style: SkeletonStyle.text,
                        textColor: Colors.grey.shade500,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
