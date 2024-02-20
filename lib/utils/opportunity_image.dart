import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/location.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/default_image.dart';

Future<ImageProvider> getImageForLocation(
  BuildContext context,
  String placeId,
) async {
  final places = context.places;
  final place = await places.getPlaceById(
    placeId,
  );

  final photoReference = place.flatMap((e) => e.photoMetadata);
  final image = await switch (photoReference) {
    None() => Future.value(const None()),
    Some(:final value) => () async {
        final image = await places.getPhotoUrlFromReference(
          placeId,
          value,
        );
        return image;
      }()
  };

  return image.match(
    () => defaultOpportunityImage,
    (t) => t.image,
  );
}

Future<ImageProvider> getOpImage(BuildContext context, Opportunity op) async {
  return await op.flierUrl.match(
    () async {
      if (op.location == Location.rva) {
        return defaultOpportunityImage;
      }

      final provider = await getImageForLocation(context, op.location.placeId);
      return provider;
    },
    CachedNetworkImageProvider.new,
  );
}
