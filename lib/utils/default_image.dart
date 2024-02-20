import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

const defaultImagesUris = [
  'assets/default_images/bob.png',
  'assets/default_images/daftpunk.png',
  'assets/default_images/deadmau5.png',
  'assets/default_images/kanye.png',
  'assets/default_images/skrillex.png',
  'assets/default_images/default_avatar.png',
];

ImageProvider<Object> get defaultOpportunityImage =>
    const AssetImage('/assets/default_images/performance_placeholder.png');

ImageProvider<Object> getDefaultImage(Option<String> id) {
  final defaultImagesLength = defaultImagesUris.length;

  // get mod of id on imageLength
  final index = switch (id) {
    None() => randomInt(0, defaultImagesLength).run(),
    Some(:final value) => value.hashCode % defaultImagesLength,
  };

// get image uri
  final uri = defaultImagesUris[index];

  return AssetImage(uri);
}
