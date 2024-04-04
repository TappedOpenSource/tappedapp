import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'performer_info.freezed.dart';

part 'performer_info.g.dart';

@freezed
class PerformerInfo with _$PerformerInfo {
  const factory PerformerInfo({
    @Default(None()) Option<String> pressKitUrl,
    @Default([]) List<String> genres,
    @Default([]) List<String> subgenres,
    @Default(Option.of(5.0)) Option<double> rating,
    @Default(0) int reviewCount,
    @Default(0) int bookingCount,
    @Default('Independent') String label,
    @Default(None()) Option<String> bookingAgency,
    @Default(PerformerCategory.undiscovered) PerformerCategory category,
    @Default(None()) Option<int> averageTicketPrice,
    @Default(None()) Option<int> averageAttendance,
    @Default(None()) Option<String> bookingEmail,
  }) = _PerformerInfo;

  // fromJson
  factory PerformerInfo.fromJson(Map<String, dynamic> json) =>
      _$PerformerInfoFromJson(json);
}

class OptionalPerformerInfoConverter
    implements JsonConverter<Option<PerformerInfo>, PerformerInfo?> {
  const OptionalPerformerInfoConverter();

  @override
  Option<PerformerInfo> fromJson(PerformerInfo? value) =>
      Option.fromNullable(value);

  @override
  PerformerInfo? toJson(Option<PerformerInfo> option) => option.toNullable();
}

extension PerformerInfoX on PerformerInfo {
  Option<String> get formattedAverageTicketPrice {
    return averageTicketPrice.map(
      (price) {
        final doublePrice = price / 100;
        final formatter = NumberFormat.compactSimpleCurrency();
        return formatter.format(doublePrice);
      },
    );
  }

  (int, int) get ticketPriceRange {
    return averageTicketPrice.fold(
      () => category.ticketPriceRange,
      (price) => switch (price) {
        < 1000 => (0, 1000),
        < 2000 => (100, 2000),
        < 4000 => (2000, 4000),
        < 7500 => (4000, 7500),
        _ => (7500, 100000),
      },
    );
  }

  String get formattedPriceRange {
    final formatter = NumberFormat.compactSimpleCurrency();
    return '${formatter.format(ticketPriceRange.$1 / 100)}-${formatter.format(ticketPriceRange.$2 / 100)}';
  }
}

@JsonEnum()
enum PerformerCategory {
  @JsonValue('undiscovered')
  undiscovered,
  @JsonValue('emerging')
  emerging,
  @JsonValue('hometownHero')
  hometownHero,
  @JsonValue('mainstream')
  mainstream,
  @JsonValue('legendary')
  legendary,
}

extension PerformerCategoryX on PerformerCategory {
  String get formattedName {
    return switch (this) {
      PerformerCategory.undiscovered => 'Undiscovered',
      PerformerCategory.emerging => 'Emerging',
      PerformerCategory.hometownHero => 'Hometown Hero',
      PerformerCategory.mainstream => 'Mainstream',
      PerformerCategory.legendary => 'Legendary',
    };
  }

  int get suggestedMaxCapacity {
    return switch (this) {
      PerformerCategory.undiscovered => 300,
      PerformerCategory.emerging => 700,
      PerformerCategory.hometownHero => 1500,
      PerformerCategory.mainstream => 100000,
      PerformerCategory.legendary => 1000000
    };
  }

  (int, int) get performerScoreRange {
    return switch (this) {
      PerformerCategory.undiscovered => (0, 33),
      PerformerCategory.emerging => (33, 66),
      PerformerCategory.hometownHero => (66, 80),
      PerformerCategory.mainstream => (80, 95),
      PerformerCategory.legendary => (95, 100),
    };
  }

  int get performerScore {
    return (performerScoreRange.$2 + performerScoreRange.$1) ~/ 2;
  }

  Color get color {
    return switch (this) {
      PerformerCategory.undiscovered => Colors.grey,
      PerformerCategory.emerging => Colors.lightBlueAccent,
      PerformerCategory.hometownHero => Colors.orange,
      PerformerCategory.mainstream => Colors.purple,
      PerformerCategory.legendary => Colors.red,
    };
  }

  String get description {
    return switch (this) {
      PerformerCategory.undiscovered =>
        'Performers who are new to the stage, with minimal audience engagement or recognition',
      PerformerCategory.emerging =>
        'Rising performers who are gaining traction and capturing the attention of audiences, showing potential for growth in their live performances.',
      PerformerCategory.hometownHero =>
        'Local performers who are celebrated and well-known within their community or region for their live shows.',
      PerformerCategory.mainstream =>
        'Performers who have achieved widespread popularity and consistently draw large crowds to their live performances.',
      PerformerCategory.legendary =>
        'Iconic performers who are revered and influential in the live performance industry, often regarded as legends by both audiences and peers.',
    };
  }

  (int, int) get ticketPriceRange {
    return switch (this) {
      PerformerCategory.undiscovered => (0, 1000),
      PerformerCategory.emerging => (1000, 2000),
      PerformerCategory.hometownHero => (2000, 4000),
      PerformerCategory.mainstream => (4000, 7500),
      PerformerCategory.legendary => (7500, 100000),
    };
  }
}
