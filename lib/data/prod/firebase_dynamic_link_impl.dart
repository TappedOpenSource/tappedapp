import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:intheloopapp/data/deep_link_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/utils/app_logger.dart';

final _dynamicLinks = FirebaseDynamicLinks.instance;
final _analytics = FirebaseAnalytics.instance;

/// The Firebase dynamic link implementation for Dynamic Link
///
/// aka Deep Links
class FirebaseDynamicLinkImpl extends DeepLinkRepository {
  @override
  Stream<DeepLinkRedirect> getDeepLinks() async* {
    // ignore: close_sinks
    final dynamicLinkStream = StreamController<DeepLinkRedirect>();

    final data = await _dynamicLinks.getInitialLink();

    final redirect = _handleDeepLink(data);
    if (redirect != null) {
      dynamicLinkStream.add(redirect);
    }

    _dynamicLinks.onLink.listen((PendingDynamicLinkData? dynamicLinkData) {
      logger.debug('new dynamic link - ${dynamicLinkData?.link}');
      final redirect = _handleDeepLink(dynamicLinkData);

      if (redirect != null) {
        dynamicLinkStream.add(redirect);
      }
    }).onError(
      (Object? error, StackTrace? stack) {
        logger.error('dynamic link error', error: error, stackTrace: stack);
      },
    );

    yield* dynamicLinkStream.stream;
  }

  DeepLinkRedirect? _handleDeepLink(
    PendingDynamicLinkData? data,
  ) {
    final deepLink = data?.link;
    logger.info('deep link: $deepLink');
    if (deepLink == null) {
      return null;
    }

    switch (deepLink.path) {
      // case '/upload_loop':
      //   return const DeepLinkRedirect(
      //     type: DeepLinkType.createPost,
      //   );
      case '/user':
        final linkParameters = deepLink.queryParameters;
        final userId = linkParameters['id'] ?? '';
        return DeepLinkRedirect(
          type: DeepLinkType.shareProfile,
          id: userId,
        );
      // case '/loop':
      //   final linkParameters = deepLink.queryParameters;
      //   final loopId = linkParameters['id'] ?? '';
      //   return DeepLinkRedirect(
      //     type: DeepLinkType.shareLoop,
      //     id: loopId,
      //   );
      case '/connect_payment':
        final linkParameters = deepLink.queryParameters;
        final accountId = linkParameters['account_id'];
        logger.info('connect payment deep link: $accountId');

        if (accountId == null) {
          logger.error('account_id is null');
          return null;
        }

        // final refresh = linkParameters['refresh'] ?? '';
        // if (refresh == 'true') {
        //   return DynamicLinkRedirect(
        //     type: DynamicLinkType.connectStripeRefresh,
        //     id: accountId,
        //   );
        // }

        return DeepLinkRedirect(
          type: DeepLinkType.connectStripeRedirect,
          id: accountId,
        );
      default:
        return null;
    }
  }

  @override
  Future<String> getShareProfileDeepLink(UserModel user) async {
    final imageUri = user.profilePicture == null
        ? Uri.parse('https://tapped.ai/images/tapped_reverse.png')
        : Uri.parse(user.profilePicture!);

    final parameters = DynamicLinkParameters(
      uriPrefix: 'https://tappednetwork.page.link',
      link: Uri.parse('https://tappednetwork.page.link/user?id=${user.id}'),
      androidParameters: const AndroidParameters(
        packageName: 'com.intheloopstudio',
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.intheloopstudio',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: '${user.displayName} on Tapped',
        description:
            '''Tapped Network - The online platform tailored for producers and creators to share their loops to the world, get feedback on their music, and join the world-wide community of artists to collaborate with''',
        imageUrl: imageUri,
      ),
    );

    final shortDynamicLink = await _dynamicLinks.buildShortLink(parameters);
    final shortUrl = shortDynamicLink.shortUrl;

    await _analytics.logShare(
      contentType: 'user',
      itemId: user.id,
      method: 'dynamic_link',
    );

    return shortUrl.toString();
  }
}
