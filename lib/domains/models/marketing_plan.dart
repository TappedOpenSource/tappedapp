class MarketingPlan {
  const MarketingPlan({
    required this.id,
    required this.userId,
    required this.type,
    required this.content,
    required this.timestamp,
  });

  final String id;
  final String userId;
  final MarketingPlanType type;
  final String content;
  final DateTime timestamp;

  MarketingPlan copyWith({
    String? id,
    String? userId,
    MarketingPlanType? type,
    String? content,
    DateTime? timestamp,
  }) {
    return MarketingPlan(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

enum MarketingPlanType {
  single,
}
