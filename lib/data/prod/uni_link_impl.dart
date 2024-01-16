import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:intheloopapp/data/deep_link_repository.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:uni_links/uni_links.dart';

final _dynamic = FirebaseDynamicLinks.instance;
final _analytics = FirebaseAnalytics.instance;

/// The unilink link implementation for Deep Link
class UniLinkImpl extends DeepLinkRepository {
  @override
  Stream<DeepLinkRedirect> getDeepLinks() async* {
    // ignore: close_sinks
    final uniLinkStream = StreamController<DeepLinkRedirect>();

    final uri = await getInitialUri();

    final redirect = _handleDeepLink(uri);
    if (redirect != null) {
      uniLinkStream.add(redirect);
    }

    uriLinkStream.listen((Uri? deepLink) {
      logger.debug('new deep link - $deepLink');
      final redirect = _handleDeepLink(deepLink);

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

  DeepLinkRedirect? _handleDeepLink(Uri? uri) {
    if (uri == null) {
      return null;
    }

    // print('_handleDeepLink | deep link: $deepLink');
    final path = uri.path;

    switch (path) {
      // case '/upload_loop':
      //   return const DeepLinkRedirect(
      //     type: DeepLinkType.createPost,
      //   );
      case '/user':
        final linkParameters = uri.queryParameters;
        final userId = linkParameters['id'] ?? '';
        return DeepLinkRedirect(
          type: DeepLinkType.shareProfile,
          id: userId,
        );
      case '/connect_payment':
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
      //TODO change this to the proper function
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

    final shortUniLink = await _dynamic.buildShortLink(parameters);
    final shortUrl = shortUniLink.shortUrl;

    await _analytics.logShare(
      contentType: 'user',
      itemId: user.id,
      method: 'dynamic_link',
    );

    return shortUrl.toString();
  }
}
