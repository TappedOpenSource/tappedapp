import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';

/// Widget used to display google place image. Used in non-web platforms
class GooglePlacesImg extends StatelessWidget {

  /// Construct a google place img using metadata and response object
  const GooglePlacesImg({
    required this.photoMetadata,
    required this.placePhotoResponse,
    super.key,
  });
  /// The photo metadata
  final PhotoMetadata photoMetadata;

  /// The photo fetch response
  final FetchPlacePhotoResponse placePhotoResponse;

  @override
  Widget build(BuildContext context) {
    return placePhotoResponse.maybeWhen(
      image: (image) => image,
      orElse: () => const Text('Invalid image'),
    );
  }
}
