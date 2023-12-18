import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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

  final photoReference = place?.photoMetadatas?.first;
  if (photoReference == null) {
    return const AssetImage(
      'assets/images/placeholder_image.png',
    );
  }

  final image = await places.getPhotoUrlFromReference(photoReference);

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
