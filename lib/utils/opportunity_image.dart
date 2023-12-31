import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

Future<ImageProvider> getImageForLocation(
  BuildContext context,
  String placeId,
) async {
  final places = context.places;
  final place = await places.getPlaceById(
    placeId,
  );

  final photoReference = place?.photoMetadata;
  if (photoReference == null) {
    return const AssetImage(
      'assets/default_avatar.png',
    );
  }

  final image = await switch (photoReference) {
    None() => Future.value(const None<Image>()),
    Some(:final value) => () async {
        final image = await places.getPhotoUrlFromReference(
          placeId,
          value,
          );
        return image;
      }()
  };

  if (image.isNone) {
    return const AssetImage(
      'assets/images/placeholder_image.png',
    );
  }

  return image.unwrap.image;
}

Future<ImageProvider> getOpImage(BuildContext context, Opportunity op) async {
  if (op.flierUrl.isSome) {
    return CachedNetworkImageProvider(
      op.flierUrl.unwrap,
    );
  }
  final provider = await getImageForLocation(context, op.placeId);
  return provider;
}
