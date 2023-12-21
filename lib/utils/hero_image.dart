
import 'package:flutter/widgets.dart';

class HeroImage {
  const HeroImage({
    required this.imageProvider,
    required this.heroTag,
  });

  final ImageProvider imageProvider;
  final String heroTag;
}
