import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

enum UniLinkType {
  createPost,
  shareLoop,
  shareProfile,
  connectStripeRedirect,
  connectStripeRefresh,
}

class UniLinkRedirect {
  const UniLinkRedirect({
    required this.type,
    this.id,
  });

  final UniLinkType type;
  final String? id;
}

abstract class DeepLinkRepository {
  Stream<UniLinkRedirect> getUniLinks();
  Future<String> getShareLoopUniLink(Loop loop);
  Future<String> getShareProfileUniLink(UserModel user);
}
