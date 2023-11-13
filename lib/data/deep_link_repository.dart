import 'package:intheloopapp/domains/models/user_model.dart';

abstract class DeepLinkRepository {
  Stream<DeepLinkRedirect> getDeepLinks();
  // Future<String> getShareLoopDeepLink(Loop loop);
  Future<String> getShareProfileDeepLink(UserModel user);
}

enum DeepLinkType {
  // createPost,
  // shareLoop,
  shareProfile,
  connectStripeRedirect,
  connectStripeRefresh,
}

class DeepLinkRedirect {
  const DeepLinkRedirect({
    required this.type,
    this.id,
  });

  final DeepLinkType type;
  final String? id;
}
