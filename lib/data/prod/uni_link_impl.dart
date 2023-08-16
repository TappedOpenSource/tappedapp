import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:intheloopapp/data/dynamic_link_repository.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:uni_links/uni_links.dart';

final _uniLinks = FirebaseDynamicLinks.instance;
final _analytics = FirebaseAnalytics.instance;

/// The Firebase dynamic link implementation for Dynamic Link
///
/// aka Deep Links
class UniLinkImpl extends UniLinkRepository {
  @override
  Stream<UniLinkRedirect> getDynamicLinks() async* {
    // ignore: close_sinks
    final uniLinkStream = StreamController<UniLinkRedirect>();

    final data = await _uniLinks.getInitialLink();

    final redirect = _handleDeepLink(data);
    if (redirect != null) {
      uniLinkStream.add(redirect);
    }

    _uniLinks.onLink.listen((PendingDynamicLinkData? dynamicLinkData) {// TODO: need to change this to the proper type
      logger.debug('new dynamic link - ${dynamicLinkData?.link}');
      final redirect = _handleDeepLink(dynamicLinkData);

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

  UniLinkRedirect? _handleDeepLink(
    PendingDynamicLinkData? data,    //TODO: Need to change this variable to the proper type
  ) {
    final deepLink = data?.link;
    if (deepLink == null) {
      return null;
    }

    // print('_handleDeepLink | deep link: $deepLink');

    switch (deepLink.path) {
      case '/upload_loop':
        return const UniLinkRedirect(
          type: UniLinkType.createPost,
        );
      case '/user':
        final linkParameters = deepLink.queryParameters;
        final userId = linkParameters['id'] ?? '';
        return UniLinkRedirect(
          type: UniLinkType.shareProfile,
          id: userId,
        );
      case '/loop':
        final linkParameters = deepLink.queryParameters;
        final loopId = linkParameters['id'] ?? '';
        return UniLinkRedirect(
          type: UniLinkType.shareLoop,
          id: loopId,
        );
      case '/connect_payment':
        final linkParameters = deepLink.queryParameters;
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

        return UniLinkRedirect(
          type: UniLinkType.connectStripeRedirect,
          id: accountId,
        );
      default:
        return null;
    }
  }

  @override
  Future<String> getShareLoopUniLink(Loop loop) async {
    final imageUri =
        (loop.imagePaths.isNotEmpty && loop.imagePaths[0].isNotEmpty)
            ? Uri.parse(loop.imagePaths[0])
            : Uri.parse('https://tapped.ai/images/tapped_reverse.png');

    final parameters = DynamicLinkParameters(    //TODO switch this function to one that makes sense
      uriPrefix: 'https://tappednetwork.page.link',
      link: Uri.parse(
        'https://tappednetwork.page.link/loop?id=${loop.id}',
      ),
      androidParameters: const AndroidParameters(
        packageName: 'com.intheloopstudio',
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.intheloopstudio',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Tapped Network | ${loop.title.unwrapOr('')}',
        description:
            '''Tapped Network - The online platform tailored for producers and creators to share their loops to the world, get feedback on their music, and join the world-wide community of artists to collaborate with''',
        imageUrl: imageUri,
      ),
    );

    final shortDynamicLink = await _uniLinks.buildShortLink(parameters);
    final shortUrl = shortDynamicLink.shortUrl;

    await _analytics.logShare(
      contentType: 'loop',
      itemId: loop.id,
      method: 'dynamic_link',
    );

    return shortUrl.toString();
  }

  @override
  Future<String> getShareProfileUniLink(UserModel user) async {
    final imageUri = user.profilePicture == null
        ? Uri.parse('https://tapped.ai/images/tapped_reverse.png')
        : Uri.parse(user.profilePicture!);

    final parameters = DynamicLinkParameters(    //TODO change this to the proper function
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

    final shortUniLink = await _uniLinks.buildShortLink(parameters);
    final shortUrl = shortUniLink.shortUrl;

    await _analytics.logShare(
      contentType: 'user',
      itemId: user.id,
      method: 'dynamic_link',
    );

    return shortUrl.toString();
  }
}
