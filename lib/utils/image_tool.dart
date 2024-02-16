import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';

extension ImageTool on ImageProvider {
  Future<Uint8List?> getBytes({
    required ImageConfiguration imageConfig,
    ImageByteFormat format = ImageByteFormat.rawRgba,
  }) async {
    final imageStream = resolve(imageConfig);
    final completer = Completer<Uint8List?>();
    final listener = ImageStreamListener(
      (imageInfo, synchronousCall) async {
        final bytes = await imageInfo.image.toByteData(format: format);
        if (!completer.isCompleted) {
          completer.complete(bytes?.buffer.asUint8List());
        }
      },
      onError: (dynamic exception, StackTrace? stackTrace) {
        completer.complete(null);
      },
    );
    imageStream.addListener(listener);
    final imageBytes = await completer.future;
    imageStream.removeListener(listener);
    return imageBytes;
  }
}
