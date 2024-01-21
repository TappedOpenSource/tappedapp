import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:intheloopapp/data/deep_link_repository.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:uni_links/uni_links.dart';

final _analytics = FirebaseAnalytics.instance;
final _firestore = FirebaseFirestore.instance;

final _usersRef = _firestore.collection('users');

/// The unilink link implementation for Deep Link
class UniLinkImpl extends DeepLinkRepository {
  UniLinkImpl() {
    uniLinkStream = StreamController<DeepLinkRedirect>();
  }

  late final StreamController<DeepLinkRedirect> uniLinkStream;

  @override
  Stream<DeepLinkRedirect> getDeepLinks() async* {
    logger.debug('initializing uni link stream');

    final uri = await getInitialUri();
    final redirect = await _handleDeepLink(uri);
    if (redirect != null) {
      uniLinkStream.add(redirect);
    }

    uriLinkStream.listen((Uri? deepLink) async {
      // logger.debug('new deep link - $deepLink');
      final redirect = await _handleDeepLink(deepLink);

      if (redirect != null) {
        uniLinkStream.add(redirect);
      }
    }).onError(
      (Object? error, StackTrace? stack) {
        logger.error('uni link error', error: error, stackTrace: stack);
      },
    );

    yield* uniLinkStream.stream;
  }

  FutureOr<DeepLinkRedirect?> _handleDeepLink(Uri? uri) async {
    if (uri == null) {
      return null;
    }

    // final path = uri.path;
    final segments = uri.pathSegments;

    // logger.info('_handleDeepLink | deep link: $uri');
    // logger.info('_handleDeepLink | segments: $segments');

    if (segments.isEmpty) {
      return null;
    }

    final firstSegment = segments.first;

    switch (firstSegment) {
      case 'b':
        if (segments.length < 2) {
          return null;
        }

        final username = segments[1];

        // get user from username
        final userRef = await _usersRef
            .where(
              'username',
              isEqualTo: username,
            )
            .get();
        if (userRef.docs.isEmpty) {
          return null;
        }

        final user = UserModel.fromDoc(userRef.docs.first);
        return ShareProfileDeepLink(
          userId: user.id,
          user: Some(user),
        );
      case 'opportunity':
        if (segments.length < 2) {
          return null;
        }

        final opportunityId = segments[1];
        return ShareOpportunityDeepLink(
          opportunityId: opportunityId,
          opportunity: const None(),
        );
      case 'settings':
        return const SettingsDeepLink();
      case 'connect_payment':
        final linkParameters = uri.queryParameters;
        final accountId = linkParameters['account_id'];
        if (accountId == null) {
          return null;
        }

        // final refresh = linkParameters['refresh'] ?? '';
        // if (refresh == 'true') {
        //   return DynamicLinkRedirect(
        //     type: DynamicLinkType.connectStripeRefresh,
        //     id: accountId,
        //   );
        // }

        return ConnectStripeRedirectDeepLink(
          id: accountId,
        );
      default:
        final username = segments.first;

        // get user from username
        final userRef = await _usersRef
            .where(
              'username',
              isEqualTo: username,
            )
            .get();
        if (userRef.docs.isEmpty) {
          return null;
        }

        final user = UserModel.fromDoc(userRef.docs.first);
        return ShareProfileDeepLink(
          userId: user.id,
          user: Some(user),
        );
    }
  }

// @override
// Future<String> getShareProfileDeepLink(UserModel user) async {
//   final imageUri = user.profilePicture == null
//       ? Uri.parse('https://tapped.ai/images/tapped_reverse.png')
//       : Uri.parse(user.profilePicture!);

//   final parameters = DynamicLinkParameters(
//     //TODO change this to the proper function
//     uriPrefix: 'https://tapped.ai',
//     link: Uri.parse('https://tappednetwork.ai/${user.username}'),
//     androidParameters: const AndroidParameters(
//       packageName: 'com.intheloopstudio',
//     ),
//     iosParameters: const IOSParameters(
//       bundleId: 'com.intheloopstudio',
//     ),
//     socialMetaTagParameters: SocialMetaTagParameters(
//       title: '${user.displayName} on Tapped',
//       description:
//           '''Tapped Network - The online platform tailored for producers and creators to share their loops to the world, get feedback on their music, and join the world-wide community of artists to collaborate with''',
//       imageUrl: imageUri,
//     ),
//   );

//   final shortUniLink = await _dynamic.buildShortLink(parameters);
//   final shortUrl = shortUniLink.shortUrl;

//   await _analytics.logShare(
//     contentType: 'user',
//     itemId: user.id,
//     method: 'dynamic_link',
//   );

//   return shortUrl.toString();
// }

// @override
// Future<String> getShareOpportunityDeepLink(Opportunity opportunity) async {
//   final imageUri = switch (opportunity.flierUrl) {
//     None() => Uri.parse('https://tapped.ai/images/tapped_reverse.png'),
//     Some(:final value) => Uri.parse(value),
//   };

//   final parameters = DynamicLinkParameters(
//     //TODO change this to the proper function
//     uriPrefix: 'https://tapped.ai',
//     link: Uri.parse('https://tapped.ai/opportunity/${opportunity.id}'),
//     androidParameters: const AndroidParameters(
//       packageName: 'com.intheloopstudio',
//     ),
//     iosParameters: const IOSParameters(
//       bundleId: 'com.intheloopstudio',
//     ),
//     socialMetaTagParameters: SocialMetaTagParameters(
//       title: '${opportunity.title} on Tapped',
//       description:
//           '''Tapped Network - The online platform tailored for producers and creators to share their loops to the world, get feedback on their music, and join the world-wide community of artists to collaborate with''',
//       imageUrl: imageUri,
//     ),
//   );

//   final shortUniLink = await _dynamic.buildShortLink(parameters);
//   final shortUrl = shortUniLink.shortUrl;

//   await _analytics.logShare(
//     contentType: 'user',
//     itemId: opportunity.id,
//     method: 'dynamic_link',
//   );

//   return shortUrl.toString();
// }
}
