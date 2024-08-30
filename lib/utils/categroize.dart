import 'package:intheloopapp/domains/models/performer_info.dart';

PerformerCategory categorizeWithWeightedDate(
    int audience,
    List<Map<String, dynamic>> capacities,
    ) {
  if (capacities.isEmpty) {
    return PerformerCategory.undiscovered;
  }

  final currentDate = DateTime.now();
  var totalWeightedCapacity = 0.0;
  var totalWeight = 0.0;

  for (final venue in capacities) {
    final venueDate = (venue['startTime'] as DateTime).isBefore(currentDate)
        ? venue['startTime'] as DateTime
        : currentDate;
    final timeDifference = currentDate.difference(venueDate).inDays / 30; // Difference in months

    final weight = 1 / (timeDifference.floor() + 1); // Weight based on months

    totalWeightedCapacity += (venue['capacity'] as int) * weight;
    totalWeight += weight;
  }

  final averageWeightedCapacity = totalWeightedCapacity / totalWeight;

  // Scale the social media following to be on a similar scale as the weighted capacity
  final scaledSocialMediaFollowing = audience / 500;

  // Combine the weighted capacity and scaled social media following
  final combinedScore = averageWeightedCapacity + scaledSocialMediaFollowing;

  if (combinedScore < 100) {
    return PerformerCategory.undiscovered;
  } else if (combinedScore < 500) {
    return PerformerCategory.emerging;
  } else if (combinedScore < 1000) {
    return PerformerCategory.hometownHero;
  } else if (combinedScore < 5000) {
    return PerformerCategory.mainstream;
  } else {
    return PerformerCategory.legendary;
  }
}