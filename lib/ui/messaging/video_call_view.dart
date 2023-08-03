import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class VideoCallView extends StatelessWidget {
  const VideoCallView({
    required this.call,
    super.key,
  });

  final Call call;

  @override
  Widget build(BuildContext context) {
    return StreamCallContainer(
      call: call,
    );
  }
}
