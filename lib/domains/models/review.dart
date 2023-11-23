import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/default_value.dart';

sealed class Review {
  const Review({
    required this.id,
    required this.bookerId,
    required this.performerId,
    required this.bookingId,
    required this.timestamp,
    required this.overallRating,
    required this.overallReview,
    required this.type,
  });

  factory Review.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      final rawType = doc.getOrElse<String?>('type', null);
      if (rawType == null) {
        throw Exception('Review.fromDoc: type is null');
      }

      final type = EnumToString.fromString(
        ReviewType.values,
        rawType,
      );

      switch (type) {
        case ReviewType.booker:
          return BookerReview.fromDoc(doc);
        case ReviewType.performer:
          return PerformerReview.fromDoc(doc);
        case null:
          throw Exception('Review.fromDoc: unknown type: $rawType');
      }
    } catch (e, s) {
      logger.error('Review.fromDoc', error: e, stackTrace: s);
      rethrow;
    }
  }

  final String id;
  final String bookerId;
  final String performerId;
  final Option<String> bookingId;

  final DateTime timestamp;

  // the star rating for the booker
  final int overallRating;

  // the star rating for the user
  final String overallReview;

  // the type of review
  final ReviewType type;

  Map<String, dynamic> toMap();
}

final class BookerReview extends Review {
  BookerReview({
    required super.id,
    required super.bookerId,
    required super.performerId,
    required super.bookingId,
    required super.timestamp,
    required super.overallRating,
    required super.overallReview,
    required super.type,
  });

  @override
  factory BookerReview.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return BookerReview(
      id: doc.id,
      bookerId: doc.get('bookerId') as String,
      performerId: doc.get('performerId') as String,
      bookingId: Option.fromNullable(
        doc.getOrElse<String?>('bookingId', null),
      ),
      timestamp: (doc.get('timestamp') as Timestamp).toDate(),
      overallRating: doc.get('overallRating') as int,
      overallReview: doc.get('overallReview') as String,
      type: ReviewType.booker,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookerId': bookerId,
      'performerId': performerId,
      'bookingId': bookingId.asNullable(),
      'timestamp': timestamp,
      'overallRating': overallRating,
      'overallReview': overallReview,
      'type': type,
    };
  }
}

final class PerformerReview extends Review {
  PerformerReview({
    required super.id,
    required super.bookerId,
    required super.performerId,
    required super.bookingId,
    required super.timestamp,
    required super.overallRating,
    required super.overallReview,
    required super.type,
  });

  @override
  factory PerformerReview.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return PerformerReview(
      id: doc.id,
      bookerId: doc.get('bookerId') as String,
      performerId: doc.get('performerId') as String,
      bookingId: Option.fromNullable(
        doc.getOrElse<String?>('bookingId', null),
      ),
      timestamp: (doc.get('timestamp') as Timestamp).toDate(),
      overallRating: doc.get('overallRating') as int,
      overallReview: doc.get('overallReview') as String,
      type: ReviewType.booker,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookerId': bookerId,
      'performerId': performerId,
      'bookingId': bookingId.asNullable(),
      'timestamp': timestamp,
      'overallRating': overallRating,
      'overallReview': overallReview,
      'type': type,
    };
  }
}

enum ReviewType {
  booker,
  performer,
}
