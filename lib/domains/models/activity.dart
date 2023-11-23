import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/default_value.dart';

sealed class Activity extends Equatable {
  const Activity({
    required this.id,
    required this.toUserId,
    required this.type,
    required this.markedRead,
    required this.timestamp,
  });

  factory Activity.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      final rawType = doc.getOrElse<String?>('type', null);
      if (rawType == null) {
        throw Exception('Activity.fromDoc: type is null');
      }

      final type = EnumToString.fromString(
        ActivityType.values,
        rawType,
      );

      switch (type) {
        case ActivityType.follow:
          return Follow.fromDoc(doc);
        case ActivityType.bookingRequest:
          return BookingRequest.fromDoc(doc);
        case ActivityType.bookingUpdate:
          return BookingUpdate.fromDoc(doc);
        case ActivityType.bookingReminder:
          return BookingReminder.fromDoc(doc);
        case ActivityType.searchAppearance:
          return SearchAppearance.fromDoc(doc);
        case null:
          throw Exception('Activity.fromDoc: unknown type: $rawType');
      }
    } catch (e, s) {
      logger.error('Activity.fromDoc', error: e, stackTrace: s);
      rethrow;
    }
  }

  final String id;
  final String toUserId;
  final DateTime timestamp;
  final ActivityType type;
  final bool markedRead;

  @override
  List<Object> get props => [
        id,
        toUserId,
        timestamp,
        type,
        markedRead,
      ];

  Activity copyAsRead();
}

final class Follow extends Activity {
  const Follow({
    required super.id,
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.fromUserId,
  });

  factory Follow.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      final tmpTimestamp = doc.getOrElse('timestamp', Timestamp.now());
      return Follow(
        id: doc.id,
        toUserId: doc.get('toUserId') as String,
        timestamp: tmpTimestamp.toDate(),
        type: EnumToString.fromString(
              ActivityType.values,
              doc.getOrElse('type', 'free'),
            ) ??
            ActivityType.follow,
        fromUserId: doc.get(
          'fromUserId',
        ) as String,
        markedRead: doc.getOrElse('markedRead', false),
      );
    } catch (e, s) {
      logger.error('FollowActivity.fromDoc', error: e, stackTrace: s);
      rethrow;
    }
  }

  final String fromUserId;

  @override
  Follow copyAsRead() {
    return Follow(
      id: id,
      fromUserId: fromUserId,
      toUserId: toUserId,
      timestamp: timestamp,
      type: type,
      markedRead: true,
    );
  }
}

final class BookingRequest extends Activity {
  const BookingRequest({
    required super.id,
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.fromUserId,
    required this.bookingId,
  });

  factory BookingRequest.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    try {
      final tmpTimestamp = doc.getOrElse('timestamp', Timestamp.now());
      return BookingRequest(
        id: doc.id,
        toUserId: doc.get('toUserId') as String,
        timestamp: tmpTimestamp.toDate(),
        type: EnumToString.fromString(
              ActivityType.values,
              doc.getOrElse('type', 'free'),
            ) ??
            ActivityType.follow,
        markedRead: doc.getOrElse('markedRead', false),
        fromUserId: doc.get(
          'fromUserId',
        ) as String,
        bookingId: doc.get(
          'bookingId',
        ) as String,
      );
    } catch (e, s) {
      logger.error('BookingRequestActivity.fromDoc', error: e, stackTrace: s);
      rethrow;
    }
  }

  final String fromUserId;
  final String bookingId;

  @override
  BookingRequest copyAsRead() {
    return BookingRequest(
      id: id,
      fromUserId: fromUserId,
      toUserId: toUserId,
      timestamp: timestamp,
      type: type,
      markedRead: true,
      bookingId: bookingId,
    );
  }
}

final class BookingUpdate extends Activity {
  const BookingUpdate({
    required super.id,
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.fromUserId,
    required this.bookingId,
    required this.status,
  });

  factory BookingUpdate.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    try {
      final tmpTimestamp = doc.getOrElse('timestamp', Timestamp.now());
      return BookingUpdate(
        id: doc.id,
        toUserId: doc.get('toUserId') as String,
        timestamp: tmpTimestamp.toDate(),
        type: EnumToString.fromString(
              ActivityType.values,
              doc.getOrElse('type', 'free'),
            ) ??
            ActivityType.follow,
        markedRead: doc.getOrElse('markedRead', false),
        fromUserId: doc.get(
          'fromUserId',
        ) as String,
        bookingId: doc.get(
          'bookingId',
        ) as String,
        status: EnumToString.fromString(
          BookingStatus.values,
          doc.get('status') as String,
        ),
      );
    } catch (e, s) {
      logger.error('BookingUpdateActivity.fromDoc', error: e, stackTrace: s);
      rethrow;
    }
  }

  final String fromUserId;
  final String bookingId;
  final BookingStatus? status;

  @override
  BookingUpdate copyAsRead() {
    return BookingUpdate(
      id: id,
      fromUserId: fromUserId,
      toUserId: toUserId,
      timestamp: timestamp,
      type: type,
      markedRead: true,
      bookingId: bookingId,
      status: status,
    );
  }
}

final class BookingReminder extends Activity {
  const BookingReminder({
    required super.id,
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.fromUserId,
    required this.bookingId,
  });

  factory BookingReminder.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    try {
      final tmpTimestamp = doc.getOrElse('timestamp', Timestamp.now());
      return BookingReminder(
        id: doc.id,
        toUserId: doc.get('toUserId') as String,
        timestamp: tmpTimestamp.toDate(),
        type: ActivityType.bookingReminder,
        markedRead: doc.getOrElse('markedRead', false),
        fromUserId: doc.get(
          'fromUserId',
        ) as String,
        bookingId: doc.get(
          'bookingId',
        ) as String,
      );
    } catch (e, s) {
      logger.error(
        'BookingReminder.fromDoc',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  final String? fromUserId;
  final String bookingId;

  @override
  BookingReminder copyAsRead() {
    return BookingReminder(
      id: id,
      fromUserId: fromUserId,
      toUserId: toUserId,
      timestamp: timestamp,
      type: type,
      markedRead: true,
      bookingId: bookingId,
    );
  }
}

final class SearchAppearance extends Activity {
  const SearchAppearance({
    required super.id,
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.count,
  });

  factory SearchAppearance.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    try {
      final tmpTimestamp = doc.getOrElse('timestamp', Timestamp.now());
      return SearchAppearance(
        id: doc.id,
        toUserId: doc.get('toUserId') as String,
        timestamp: tmpTimestamp.toDate(),
        type: ActivityType.searchAppearance,
        markedRead: doc.getOrElse('markedRead', false),
        count: doc.get('count') as int,
      );
    } catch (e, s) {
      logger.error(
        'SearchAppearanceNotification.fromDoc',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  final int count;

  @override
  SearchAppearance copyAsRead() {
    return SearchAppearance(
      id: id,
      toUserId: toUserId,
      timestamp: timestamp,
      type: type,
      markedRead: true,
      count: count,
    );
  }
}

enum ActivityType {
  follow,
  bookingRequest,
  bookingUpdate,
  bookingReminder,
  searchAppearance,
}
