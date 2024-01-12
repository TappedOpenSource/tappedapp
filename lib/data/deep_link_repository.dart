import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

abstract class DeepLinkRepository {
  Stream<DeepLinkRedirect> getDeepLinks();
  Future<String> getShareProfileDeepLink(UserModel user);
  Future<String> getShareOpportunityDeepLink(Opportunity opportunity);
}

enum DeepLinkType {
  shareProfile,
  shareOpportunity,
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
