import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:georange/georange.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/activity.dart';
import 'package:intheloopapp/domains/models/badge.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/comment.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/review.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/default_value.dart';
import 'package:intheloopapp/utils/geohash.dart';
import 'package:rxdart/rxdart.dart';

// final _storage = FirebaseStorage.instance.ref();
final _firestore = FirebaseFirestore.instance;
final _analytics = FirebaseAnalytics.instance;

final _usersRef = _firestore.collection('users');
final _followersRef = _firestore.collection('followers');
final _followingRef = _firestore.collection('following');
// final _loopsRef = _firestore.collection('loops');
// final _feedRefs = _firestore.collection('feeds');
final _activitiesRef = _firestore.collection('activities');
final _commentsRef = _firestore.collection('comments');
final _badgesRef = _firestore.collection('badges');
final _badgesSentRef = _firestore.collection('badgesSent');
final _bookingsRef = _firestore.collection('bookings');
final _servicesRef = _firestore.collection('services');
final _mailRef = _firestore.collection('mail');
final _leadersRef = _firestore.collection('leaderboard');
final _blockerRef = _firestore.collection('blockers');
// final _blockeeRef = _firestore.collection('blockees');
final _reviewsRef = _firestore.collection('reviews');
final _opportunitiesRef = _firestore.collection('opportunities');
final _opportunityFeedsRef = _firestore.collection('opportunityFeeds');
final _creditsRef = _firestore.collection('credits');
final _premiumWailistRef = _firestore.collection('premiumWaitlist');

const verifiedBadgeId = '0aa46576-1fbe-4312-8b69-e2fef3269083';

const commentsSubcollection = 'loopComments';
const likesSubcollection = 'loopLikes';
const feedSubcollection = 'userFeed';

const blockerSubcollection = 'blockedUsers';
const blockeeSubcollection = 'blockedByUsers';

const bookerReviewsSubcollection = 'bookerReviews';
const performerReviewsSubcollection = 'performerReviews';

/// Database implementation using Firebase's FirestoreDB
class FirestoreDatabaseImpl extends DatabaseRepository {
  String _getFileFromURL(String fileURL) {
    final fSlashes = fileURL.split('/');
    final fQuery = fSlashes[fSlashes.length - 1].split('?');
    final segments = fQuery[0].split('%2F');
    final fileName = segments.join('/');

    return fileName;
  }

  // true if username available, false otherwise
  @override
  Future<bool> checkUsernameAvailability(
    String username,
    String userid,
  ) async {
    final blacklist = ['anonymous', '*deleted*'];

    final reserverd = [
      'mictheplug',
      'bobbyshmurda',
      'aboogie',
      'teegrizley',
      'loganpaul',
      'mikemajlak',
      'keyglock',
      'mrbeast',
      'keemokazi',
    ];

    if (blacklist.contains(username) || reserverd.contains(username)) {
      // print('''
      //   username check for blacklisted item:
      //     userId: ${data.userId},
      //     username: ${data.username}
      // ''');
      return false;
    }

    final userQuery =
        await _usersRef.where('username', isEqualTo: username).get();
    if (userQuery.docs.isNotEmpty && userQuery.docs.first.id != userid) {
      // print('''
      //   username check for already taken username:
      //     userId: ${data.userId},
      //     username: ${data.username}
      // ''');
      return false;
    }

    // print('''
    //   username check for available username:
    //     userId: ${data.userId},
    //     username: ${data.username}
    // ''');
    return true;
  }

  @override
  Future<bool> userEmailExists(String email) async {
    final userSnapshot = await _usersRef.where('email', isEqualTo: email).get();

    return userSnapshot.docs.isNotEmpty;
  }

  @override
  Future<void> createUser(UserModel user) async {
    try {
      await _analytics.logEvent(name: 'onboarding_user');

      final userAlreadyExists = (await _usersRef.doc(user.id).get()).exists;
      if (userAlreadyExists) {
        return;
      }

      final usernameAvailable = await checkUsernameAvailability(
        user.username.toString(),
        user.id,
      );
      if (!usernameAvailable) {
        throw HandleAlreadyExistsException(
          'username availability check failed',
        );
      }

      await _usersRef.doc(user.id).set(user.toMap());
    } catch (e, s) {
      logger.error(
        'createUser',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  Future<Option<UserModel>> getUserByUsername(String? username) async {
    if (username == null) return const None();

    final userSnapshots =
        await _usersRef.where('username', isEqualTo: username).get();

    if (userSnapshots.docs.isNotEmpty) {
      return Some(UserModel.fromDoc(userSnapshots.docs.first));
    }

    return const None();
  }

  @override
  Future<Option<UserModel>> getUserById(
    String userId, {
    bool ignoreCache = true,
  }) async {
    DocumentSnapshot<Map<String, dynamic>>? userSnapshot;
    if (!ignoreCache) {
      try {
        userSnapshot = await _usersRef.doc(userId).get(
              const GetOptions(source: Source.cache),
            );
      } on FirebaseException {
        userSnapshot = await _usersRef.doc(userId).get();
      } catch (e, s) {
        logger.error(
          'getUserById',
          error: e,
          stackTrace: s,
        );
      }
    }

    userSnapshot ??= await _usersRef.doc(userId).get();

    if (!userSnapshot.exists) {
      return const None();
    }

    try {
      final user = UserModel.fromDoc(userSnapshot);
      return Some(user);
    } catch (e, s) {
      logger.error(
        'getUserById',
        error: e,
        stackTrace: s,
      );
      return const None();
    }
  }

  @override
  Future<List<UserModel>> searchUsersByLocation({
    required double lat,
    required double lng,
    int radiusInMeters = 100 * 1000, // 100km
    int limit = 30,
    String? lastUserId,
  }) async {
    final range = getGeohashRange(
      latitude: lat,
      longitude: lng,
      distance: radiusInMeters ~/ 1000,
    );

    if (lastUserId != null) {
      final documentSnapshot = await _usersRef.doc(lastUserId).get();

      final usersSnapshot = await _usersRef
          .orderBy('geohash')
          .where('geohash', isGreaterThanOrEqualTo: range.lower)
          .where('geohash', isLessThanOrEqualTo: range.upper)
          .limit(limit)
          .startAfterDocument(documentSnapshot)
          .get();

      if (usersSnapshot.docs.isEmpty) {
        return [];
      }

      final usersWithFP = usersSnapshot.docs.map(UserModel.fromDoc).toList();

      final users = usersWithFP
          .map((user) {
            if (user.lat == null || user.lng == null) {
              return null;
            }

            // We have to filter out a few false positives due to GeoHash
            // accuracy, but most will match
            final distanceInKm = geoDistance(
              Point(latitude: user.lat!, longitude: user.lng!),
              Point(latitude: lat, longitude: lng),
            );

            final distanceInM = distanceInKm * 1000;
            if (distanceInM > radiusInMeters) {
              return null;
            }

            return user;
          })
          .where((e) => e != null)
          .whereType<UserModel>()
          .toList();

      return users;
    } else {
      final usersSnapshot = await _usersRef
          .orderBy('geohash')
          .where('geohash', isGreaterThanOrEqualTo: range.lower)
          .where('geohash', isLessThanOrEqualTo: range.upper)
          .limit(limit)
          .get();

      if (usersSnapshot.docs.isEmpty) {
        return [];
      }

      final usersWithFP = usersSnapshot.docs.map(UserModel.fromDoc).toList();

      final users = usersWithFP
          .map((user) {
            if (user.lat == null || user.lng == null) {
              return null;
            }

            // We have to filter out a few false positives due to GeoHash
            // accuracy, but most will match
            final distanceInKm = geoDistance(
              Point(latitude: user.lat!, longitude: user.lng!),
              Point(latitude: lat, longitude: lng),
            );

            final distanceInM = distanceInKm * 1000;
            if (distanceInM > radiusInMeters) {
              return null;
            }

            return user;
          })
          .where((e) => e != null)
          .whereType<UserModel>()
          .toList();

      return users;
    }
  }

  @override
  Future<List<UserModel>> getRichmondVenues() async {
    final leadersSnapshot = await _leadersRef.doc('leaders').get();

    final leadingUsernames =
        leadersSnapshot.getOrElse('richmondVenues', <dynamic>[]);

    final leaders = await Future.wait(
      leadingUsernames.map(
        (username) async {
          final user = await getUserByUsername(username as String);
          return user;
        },
      ),
    );

    return leaders.whereType<Some<UserModel>>().map((e) => e.unwrap).toList();
  }

  @override
  Future<List<UserModel>> getBookingLeaders() async {
    final leadersSnapshot = await _leadersRef.doc('leaders').get();

    final leadingUsernames =
        leadersSnapshot.getOrElse('bookingLeaders', <dynamic>[]);

    final leaders = await Future.wait(
      leadingUsernames.map(
        (username) async {
          final user = await getUserByUsername(username as String);
          return user;
        },
      ),
    );

    return leaders.whereType<Some<UserModel>>().map((e) => e.unwrap).toList();
  }

  @override
  Future<List<UserModel>> getBookerLeaders() async {
    final leadersSnapshot = await _leadersRef.doc('leaders').get();

    final leadingUsernames =
        leadersSnapshot.getOrElse('bookerLeaders', <dynamic>[]);

    final leaders = await Future.wait(
      leadingUsernames.map(
        (username) async {
          final user = await getUserByUsername(username as String);
          return user;
        },
      ),
    );

    return leaders.whereType<Some<UserModel>>().map((e) => e.unwrap).toList();
  }

  @override
  Future<List<Opportunity>> getFeaturedOpportunities() async {
    final leadersSnapshot = await _leadersRef.doc('leaders').get();
    final leadingOps =
        leadersSnapshot.getOrElse('featuredOpportunities', <dynamic>[]);

    final ops = await Future.wait(
      leadingOps.map(
        (opId) async {
          final op = await getOpportunityById(opId as String);
          return op;
        },
      ),
    );

    return ops;
  }

  @override
  Future<int> followersNum(String userid) async {
    try {
      final followersSnapshot =
          await _followersRef.doc(userid).collection('Followers').get();

      return followersSnapshot.docs.length;
    } catch (e, s) {
      logger.error('followersNum', error: e, stackTrace: s);
      return 0;
    }
  }

  @override
  Future<int> followingNum(String userid) async {
    try {
      final followingSnapshot =
          await _followingRef.doc(userid).collection('Following').get();

      return followingSnapshot.docs.length;
    } catch (e, s) {
      logger.error('followingNum', error: e, stackTrace: s);
      return 0;
    }
  }

  @override
  Future<void> updateUserData(UserModel user) async {
    try {
      await _analytics.logEvent(name: 'user_data_update');
      final isUsernameAvailable =
          await checkUsernameAvailability(user.username.toString(), user.id);
      if (!isUsernameAvailable) {
        throw HandleAlreadyExistsException(
          'username availability check failed',
        );
      }

      await _usersRef.doc(user.id).update(user.toMap());
    } catch (e, s) {
      logger.error('updateUserData', error: e, stackTrace: s);
    }
  }

  @override
  Future<void> followUser(
    String currentUserId,
    String visitedUserId,
  ) async {
    try {
      await _analytics.logEvent(
        name: 'follow_user',
        parameters: {
          'follower': currentUserId,
          'followee': visitedUserId,
        },
      );
      await _followingRef
          .doc(currentUserId)
          .collection('Following')
          .doc(visitedUserId)
          .set({});
    } catch (e, s) {
      logger.error('followUser', error: e, stackTrace: s);
    }
  }

  @override
  Future<void> unfollowUser(
    String currentUserId,
    String visitedUserId,
  ) async {
    try {
      await _analytics.logEvent(
        name: 'unfollow_user',
        parameters: {
          'follower': currentUserId,
          'followed': visitedUserId,
        },
      );
      final doc = await _followingRef
          .doc(currentUserId)
          .collection('Following')
          .doc(visitedUserId)
          .get();

      await doc.reference.delete();
    } catch (e, s) {
      logger.error('unfollowUser', error: e, stackTrace: s);
    }
  }

  @override
  Future<bool> isFollowingUser(
    String currentUserId,
    String visitedUserId,
  ) async {
    try {
      final followingDoc = await _followingRef
          .doc(currentUserId)
          .collection('Following')
          .doc(visitedUserId)
          .get();
      return followingDoc.exists;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<UserModel>> getFollowing(String currentUserId) async {
    final userFollowingSnapshot =
        await _followingRef.doc(currentUserId).collection('Following').get();

    final followingFutures = userFollowingSnapshot.docs.map(
      (doc) async {
        final userDoc = await _usersRef.doc(doc.id).get();
        return UserModel.fromDoc(userDoc);
      },
    ).toList();

    final following = await Future.wait(followingFutures);

    return following;
  }

  @override
  Future<List<UserModel>> getFollowers(String currentUserId) async {
    final userFollowerSnapshot =
        await _followersRef.doc(currentUserId).collection('Followers').get();

    final followerFutures = userFollowerSnapshot.docs.map(
      (doc) async {
        final userDoc = await _usersRef.doc(doc.id).get();
        return UserModel.fromDoc(userDoc);
      },
    ).toList();

    final followers = await Future.wait(followerFutures);

    return followers;
  }

  @override
  Future<List<UserModel>> getCommonFollowers(
    String currentUserID,
    String observedUserId,
  ) async {
    final [userFollowingSnapshot, followsViewedSnapshot] = await Future.wait([
      //current user must follow a person to qualify
      getFollowing(currentUserID),

      //person must follow the observed to qualify
      getFollowers(observedUserId),
    ]);
    final result = userFollowingSnapshot
        .toSet()
        .intersection(followsViewedSnapshot.toSet());
    final intersection = await Future.wait(
      result.map((id) async {
        final user = await getUserById(id.id);
        return user.asNullable();
      }),
    );

    return intersection.whereType<UserModel>().toList();
  }

  @override
  Future<List<Activity>> getActivities(
    String userId, {
    int limit = 30,
    String? lastActivityId,
  }) async {
    if (lastActivityId != null) {
      final documentSnapshot = await _activitiesRef.doc(lastActivityId).get();

      final activitiesSnapshot = await _activitiesRef
          .orderBy('timestamp', descending: true)
          .where('toUserId', isEqualTo: userId)
          .limit(limit)
          .startAfterDocument(documentSnapshot)
          .get();

      final activities = activitiesSnapshot.docs
          .map((activity) {
            try {
              return Activity.fromDoc(activity);
            } catch (e) {
              // if (kDebugMode) {
              //   logger.error('getActivities', error: e, stackTrace: s);
              // }
              return null;
            }
          })
          .where((element) => element != null)
          .whereType<Activity>()
          .toList();

      return activities;
    } else {
      final activitiesSnapshot = await _activitiesRef
          .orderBy('timestamp', descending: true)
          .where('toUserId', isEqualTo: userId)
          .limit(limit)
          .get();

      final activities = activitiesSnapshot.docs
          .map((activity) {
            try {
              return Activity.fromDoc(activity);
            } catch (e) {
              // if (kDebugMode) {
              //   logger.error('getActivities', error: e, stackTrace: s);
              // }
              return null;
            }
          })
          .where((element) => element != null)
          .whereType<Activity>()
          .toList();

      return activities;
    }
  }

  @override
  Stream<Activity> activitiesObserver(
    String userId, {
    int limit = 30,
  }) async* {
    final activitiesSnapshotObserver = _activitiesRef
        .orderBy('timestamp', descending: true)
        .where('toUserId', isEqualTo: userId)
        .limit(limit)
        .snapshots();

    final activitiesObserver = activitiesSnapshotObserver
        .map((event) {
          return event.docChanges
              .where(
            (DocumentChange<Map<String, dynamic>> element) =>
                element.type == DocumentChangeType.added,
          )
              .map((DocumentChange<Map<String, dynamic>> element) {
            try {
              return Activity.fromDoc(element.doc);
            } catch (e) {
              // if (kDebugMode) {
              //   logger.error('activitiesObserver', error: e, stackTrace: s);
              // }
              return null;
            }
            // if (element.type == DocumentChangeType.modified) {}
            // if (element.type == DocumentChangeType.removed) {}
          });
        })
        .flatMap(Stream.fromIterable)
        .whereType<Activity>();

    yield* activitiesObserver;
  }

  @override
  Future<void> addActivity({
    required String currentUserId,
    required ActivityType type,
    required String visitedUserId,
    Loop? loop,
  }) async {
    await _analytics.logEvent(
      name: 'new_activity',
      parameters: {
        'from_user_id': currentUserId,
        'to_user_id': visitedUserId,
        'type': EnumToString.convertToString(type),
      },
    );

    await _activitiesRef.add({
      'toUserId': visitedUserId,
      'fromUserId': currentUserId,
      'timestamp': Timestamp.now(),
      'type': EnumToString.convertToString(type),
    });
  }

  @override
  Future<void> markActivityAsRead(Activity activity) async {
    await _analytics.logEvent(
      name: 'activity_read',
      parameters: {
        'activity_id': activity.id,
      },
    );
    await _activitiesRef.doc(activity.id).update({
      'markedRead': true,
    });
  }

  @override
  Future<List<Comment>> getComments(
    String rootId, {
    int limit = 30,
  }) async {
    final commentsSnapshot = await _commentsRef
        .doc(rootId)
        .collection(commentsSubcollection)
        .orderBy('timestamp')
        // .where('parentId', isNull: true) // Needed for threaded comments
        .limit(limit)
        .get();

    final comments = commentsSnapshot.docs.map(Comment.fromDoc).toList();

    return comments;
  }

  @override
  Stream<Comment> commentsObserver(
    String rootId, {
    int limit = 30,
  }) async* {
    final commentsSnapshotObserver = _commentsRef
        .doc(rootId)
        .collection(commentsSubcollection)
        .orderBy('timestamp')
        .limit(limit)
        // .where('parentId', isNull: true) // Needed for threaded comments
        .snapshots();

    final commentsObserver = commentsSnapshotObserver
        .map((event) {
          return event.docChanges
              .where(
            (DocumentChange<Map<String, dynamic>> element) =>
                element.type == DocumentChangeType.added,
          )
              .map((DocumentChange<Map<String, dynamic>> element) {
            try {
              return Comment.fromDoc(element.doc);
            } catch (e, s) {
              logger.error('Error parsing comment', error: e, stackTrace: s);
              return null;
            }
            // if (element.type == DocumentChangeType.modified) {}
            // if (element.type == DocumentChangeType.removed) {}
          });
        })
        .flatMap(Stream.fromIterable)
        .whereType<Comment>();

    yield* commentsObserver;
  }

  @override
  Future<Comment> getComment(
    String rootId,
    String commentId,
  ) async {
    final commentSnapshot = await _commentsRef
        .doc(rootId)
        .collection(commentsSubcollection)
        .doc(commentId)
        .get();

    final comment = Comment.fromDoc(commentSnapshot);

    return comment;
  }

  @override
  Future<void> addComment(
    Comment comment,
  ) async {
    await _analytics.logEvent(
      name: 'new_comment',
      parameters: {
        'root_id': comment.rootId,
        'user_id': comment.userId,
      },
    );

    await _commentsRef
        .doc(comment.rootId)
        .collection(commentsSubcollection)
        .doc(comment.id)
        .set(comment.toMap());
  }

  @override
  Future<void> likeComment(
    String currentUserId,
    Comment comment,
  ) async {
    await _analytics.logEvent(
      name: 'like_comment',
      parameters: {
        'comment_id': comment.id,
        'user_id': currentUserId,
      },
    );

    await _commentsRef
        .doc(comment.rootId)
        .collection(commentsSubcollection)
        .doc(comment.id)
        .collection('commentLikes')
        .doc(currentUserId)
        .set({});
  }

  @override
  Future<void> unlikeComment(
    String currentUserId,
    Comment comment,
  ) async {
    await _analytics.logEvent(
      name: 'unlike_comment',
      parameters: {
        'comment_id': comment.id,
        'user_id': currentUserId,
      },
    );

    await _commentsRef
        .doc(comment.rootId)
        .collection(commentsSubcollection)
        .doc(comment.id)
        .collection('commentLikes')
        .doc(currentUserId)
        .delete();
  }

  @override
  Future<bool> isCommentLiked(
    String currentUserId,
    Comment comment,
  ) async {
    final commentLikeSnapshot = await _commentsRef
        .doc(comment.rootId)
        .collection(commentsSubcollection)
        .doc(comment.id)
        .collection('commentLikes')
        .doc(currentUserId)
        .get();

    return commentLikeSnapshot.exists;
  }

  @override
  Future<bool> isVerified(
    String userId, {
    bool ignoreCache = true,
  }) async {
    final options = ignoreCache
        ? const GetOptions(source: Source.server)
        : const GetOptions(source: Source.cache);

    try {
      final verifiedBadgeSentDoc = await _badgesSentRef
          .doc(userId)
          .collection('badges')
          .doc(verifiedBadgeId)
          .get(
            options,
          );

      final isVerified = verifiedBadgeSentDoc.exists;

      return isVerified;
    } on FirebaseException {
      return false;
    }
  }

  @override
  Stream<Badge> userBadgesObserver(
    String userId, {
    int limit = 30,
  }) async* {
    final userBadgesSnapshotObserver = _badgesSentRef
        .doc(userId)
        .collection('badges')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots();

    final userBadgesObserver = userBadgesSnapshotObserver.map((event) {
      return event.docChanges
          .where(
        (DocumentChange<Map<String, dynamic>> element) =>
            element.type == DocumentChangeType.added,
      )
          .map((DocumentChange<Map<String, dynamic>> element) async {
        final badgeId = element.doc.id;
        // print('BADGE ID { $badgeId }');
        final badgeSnapshot = await _badgesRef.doc(badgeId).get();
        return Badge.fromDoc(badgeSnapshot);
      });
    }).flatMap(Stream.fromIterable);

    await for (final badge in userBadgesObserver) {
      try {
        yield await badge;
      } catch (error, stack) {
        yield* Stream.error(error, stack);
      }
    }
  }

  @override
  Future<List<Badge>> getUserBadges(
    String userId, {
    int limit = 30,
    String? lastBadgeId,
  }) async {
    if (lastBadgeId != null) {
      final documentSnapshot = await _badgesSentRef
          .doc(userId)
          .collection('badges')
          .doc(lastBadgeId)
          .get();

      final userBadgesSnapshot = await _badgesSentRef
          .doc(userId)
          .collection('badges')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .startAfterDocument(documentSnapshot)
          .get();

      final userBadges = Future.wait(
        userBadgesSnapshot.docs.map((doc) async {
          final badgeId = doc.getOrElse('badgeId', '');
          final badgeSnapshot = await _badgesRef.doc(badgeId).get();
          return Badge.fromDoc(badgeSnapshot);
        }).toList(),
      );
      return userBadges;
    } else {
      final userBadgesSnapshot = await _badgesSentRef
          .doc(userId)
          .collection('badges')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      final userBadges = Future.wait(
        userBadgesSnapshot.docs.map((doc) async {
          final badgeId = doc.id;
          final badgeSnapshot = await _badgesRef.doc(badgeId).get();
          return Badge.fromDoc(badgeSnapshot);
        }).toList(),
      );
      return userBadges;
    }
  }

  @override
  Future<void> createBooking(
    Booking booking,
  ) async {
    await _analytics.logEvent(
      name: 'booking_created',
      parameters: {
        'requester_id': booking.requesterId,
        'requestee_id': booking.requesteeId,
        'rate': booking.rate,
        'total': booking.totalCost,
        'booking_id': booking.id,
      },
    );
    await _bookingsRef.doc(booking.id).set(booking.toMap());
  }

  @override
  Future<Option<Booking>> getBookingById(
    String bookRequestId,
  ) async {
    try {
      final bookingSnapshot = await _bookingsRef.doc(bookRequestId).get();
      final bookingRequest = Booking.fromDoc(bookingSnapshot);

      return Some(bookingRequest);
    } catch (e, s) {
      logger.error(
        'Error getting booking by id',
        error: e,
        stackTrace: s,
      );
      return const None();
    }
  }

  @override
  Future<List<Booking>> getBookingsByRequesterRequestee(
    String requesterId,
    String requesteeId, {
    int limit = 20,
    String? lastBookingRequestId,
    BookingStatus? status,
  }) async {
    final bookingSnapshot = await (() {
      if (status == null) {
        return _bookingsRef
            .where(
              'requesterId',
              isEqualTo: requesterId,
            )
            .where(
              'requesteeId',
              isEqualTo: requesteeId,
            )
            .get();
      }

      return _bookingsRef
          .where(
            'requesterId',
            isEqualTo: requesterId,
          )
          .where(
            'requesteeId',
            isEqualTo: requesteeId,
          )
          .where('status', isEqualTo: EnumToString.convertToString(status))
          .get();
    })();

    final bookingRequests = bookingSnapshot.docs.map(Booking.fromDoc).toList();

    return bookingRequests;
  }

  @override
  Future<List<Booking>> getBookingsByRequester(
    String userId, {
    int limit = 20,
    String? lastBookingRequestId,
    BookingStatus? status,
  }) async {
    try {
      final bookingSnapshot = await (() {
        if (status == null) {
          return _bookingsRef
              .where(
                'requesterId',
                isEqualTo: userId,
              )
              .get();
        }

        return _bookingsRef
            .where(
              'requesterId',
              isEqualTo: userId,
            )
            .where('status', isEqualTo: EnumToString.convertToString(status))
            .get();
      })();

      final bookingRequests =
          bookingSnapshot.docs.map(Booking.fromDoc).toList();

      return bookingRequests;
    } catch (e, s) {
      logger.error(
        'error getting bookings by requester',
        error: e,
        stackTrace: s,
      );
      return [];
    }
  }

  @override
  Stream<Booking> getBookingsByRequesterObserver(
    String userId, {
    int limit = 20,
    BookingStatus? status,
  }) async* {
    final bookingsSnapshotObserver = (() {
      if (status == null) {
        return _bookingsRef
            .where('requesterId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .limit(limit)
            .snapshots();
      }

      return _bookingsRef
          .where('requesterId', isEqualTo: userId)
          .where('status', isEqualTo: EnumToString.convertToString(status))
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .snapshots();
    })();

    final bookingsObserver = bookingsSnapshotObserver.map((event) {
      return event.docChanges
          .where(
        (DocumentChange<Map<String, dynamic>> element) =>
            element.type == DocumentChangeType.added,
      )
          .map((DocumentChange<Map<String, dynamic>> element) async {
        final bookingId = element.doc.id;
        // print('BOOKING ID { $bookingId }');
        final bookingSnapshot = await _bookingsRef.doc(bookingId).get();
        return Booking.fromDoc(bookingSnapshot);
      });
    }).flatMap(Stream.fromIterable);

    await for (final booking in bookingsObserver) {
      try {
        yield await booking;
      } catch (error, stack) {
        yield* Stream.error(error, stack);
      }
    }
  }

  @override
  Future<List<Booking>> getBookingsByRequestee(
    String userId, {
    int limit = 20,
    String? lastBookingRequestId,
    BookingStatus? status,
  }) async {
    try {
      final bookingSnapshot = await (() {
        if (status == null) {
          return _bookingsRef
              .where(
                'requesteeId',
                isEqualTo: userId,
              )
              .get();
        }

        return _bookingsRef
            .where(
              'requesteeId',
              isEqualTo: userId,
            )
            .where('status', isEqualTo: EnumToString.convertToString(status))
            .get();
      })();

      final bookingRequests =
          bookingSnapshot.docs.map(Booking.fromDoc).toList();

      return bookingRequests;
    } catch (e, s) {
      logger.error(
        'error getting bookings by requestee',
        error: e,
        stackTrace: s,
      );
      return [];
    }
  }

  @override
  Stream<Booking> getBookingsByRequesteeObserver(
    String userId, {
    int limit = 20,
    BookingStatus? status,
  }) async* {
    final bookingsSnapshotObserver = (() {
      if (status == null) {
        return _bookingsRef
            .where('requesteeId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .limit(limit)
            .snapshots();
      }

      return _bookingsRef
          .where('requesteeId', isEqualTo: userId)
          .where('status', isEqualTo: EnumToString.convertToString(status))
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .snapshots();
    })();

    final bookingsObserver = bookingsSnapshotObserver.map((event) {
      return event.docChanges
          .where(
        (DocumentChange<Map<String, dynamic>> element) =>
            element.type == DocumentChangeType.added,
      )
          .map((DocumentChange<Map<String, dynamic>> element) async {
        final bookingId = element.doc.id;
        // print('BOOKING ID { $bookingId }');
        final bookingSnapshot = await _bookingsRef.doc(bookingId).get();
        return Booking.fromDoc(bookingSnapshot);
      });
    }).flatMap(Stream.fromIterable);

    await for (final booking in bookingsObserver) {
      try {
        yield await booking;
      } catch (error, stack) {
        yield* Stream.error(error, stack);
      }
    }
  }

  @override
  Future<void> updateBooking(Booking booking) async {
    try {
      await _analytics.logEvent(
        name: 'update_booking',
        parameters: {
          'status': EnumToString.convertToString(booking.status),
        },
      );
      await _bookingsRef.doc(booking.id).set(booking.toMap());
    } catch (e, s) {
      logger.error(
        'error updating booking',
        error: e,
        stackTrace: s,
      );
    }
  }

  @override
  Future<void> createService(Service service) async {
    try {
      await _analytics.logEvent(
        name: 'service_created',
        parameters: {
          'service_id': service.id,
          'user_id': service.userId,
          'title': service.title,
          'description': service.description,
          'rate': service.rate,
          'rate_type': service.rateType.name,
        },
      );
      await _servicesRef
          .doc(service.userId)
          .collection('userServices')
          .doc(service.id)
          .set(service.toJson());
    } catch (e, s) {
      logger.error('createService', error: e, stackTrace: s);
    }
  }

  @override
  Future<void> deleteService(String userId, String serviceId) async {
    try {
      await _analytics.logEvent(
        name: 'service_deleted',
      );
      await _servicesRef
          .doc(userId)
          .collection('userServices')
          .doc(serviceId)
          .update({
        'userId': userId,
        'deleted': true,
      });
    } catch (e, s) {
      logger.error('deleteService', error: e, stackTrace: s);
    }
  }

  @override
  Future<Option<Service>> getServiceById(
    String userId,
    String serviceId,
  ) async {
    try {
      final serviceSnapshot = await _servicesRef
          .doc(userId)
          .collection('userServices')
          .doc(serviceId)
          .get();

      final service = Service.fromDoc(serviceSnapshot);

      return Some(service);
    } catch (e, s) {
      logger.error(
        'getServiceById - $userId - $serviceId',
        error: e,
        stackTrace: s,
      );
      return const None();
    }
  }

  @override
  Future<List<Service>> getUserServices(String userId) async {
    try {
      final userServicesSnapshot = await _servicesRef
          .doc(userId)
          .collection('userServices')
          .where('deleted', isNotEqualTo: true)
          .get();

      final services = userServicesSnapshot.docs.map(Service.fromDoc).toList();

      return services;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> updateService(Service service) async {
    try {
      await _analytics.logEvent(
        name: 'service_updated',
        parameters: service.toJson(),
      );
      await _servicesRef
          .doc(service.userId)
          .collection('userServices')
          .doc(service.id)
          .set(service.toJson());
    } catch (e, s) {
      logger.error('updateService', error: e, stackTrace: s);
    }
  }

  @override
  Future<Opportunity> getOpportunityById(String opportunityId) async {
    try {
      final opportunitySnapshot =
          await _opportunitiesRef.doc(opportunityId).get();

      final opportunity = Opportunity.fromDoc(opportunitySnapshot);

      return opportunity;
    } catch (e, s) {
      logger.error('getOpportunityById', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<List<Opportunity>> getOpportunities({
    int limit = 20,
    String? lastOpportunityId,
  }) async {
    if (lastOpportunityId != null) {
      final documentSnapshot =
          await _opportunitiesRef.doc(lastOpportunityId).get();

      final opportunitiesSnapshot = await _opportunitiesRef
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .startAfterDocument(documentSnapshot)
          .get();

      final opportunities =
          opportunitiesSnapshot.docs.map(Opportunity.fromDoc).toList();

      return opportunities;
    }

    final opportunitiesSnapshot = await _opportunitiesRef
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();

    final opportunities =
        opportunitiesSnapshot.docs.map(Opportunity.fromDoc).toList();

    return opportunities;
  }

  @override
  Future<List<Opportunity>> getOpportunitiesByUserId(String userId) async {
    try {
      final userOpportunitiesSnapshot = await _opportunitiesRef
          .where('userId', isEqualTo: userId)
          .where('startDate', isGreaterThanOrEqualTo: Timestamp.now())
          .orderBy('startDate', descending: true)
          .get();

      final opportunities =
          userOpportunitiesSnapshot.docs.map(Opportunity.fromDoc).toList();

      return opportunities;
    } catch (e, s) {
      logger.error('getUserOpportunities', error: e, stackTrace: s);
      return [];
    }
  }

  @override
  Future<bool> isUserAppliedForOpportunity({
    required String userId,
    required Opportunity opportunity,
  }) async {
    try {
      final userSnapshot = await _opportunitiesRef
          .doc(opportunity.id)
          .collection('interestedUsers')
          .doc(userId)
          .get();

      return userSnapshot.exists;
    } catch (e, s) {
      logger.error('isAppliedForOpportunity', error: e, stackTrace: s);
      return false;
    }
  }

  @override
  Future<List<UserModel>> getInterestedUsers(Opportunity opportunity) async {
    try {
      final interestedUsersSnapshot = await _opportunitiesRef
          .doc(opportunity.id)
          .collection('interestedUsers')
          .get();

      final interestedUsers = await Future.wait(
        interestedUsersSnapshot.docs.map((doc) async {
          final userSnapshot = await _usersRef.doc(doc.id).get();
          return UserModel.fromDoc(userSnapshot);
        }),
      );

      return interestedUsers;
    } catch (e, s) {
      logger.error('getInterestedUsers', error: e, stackTrace: s);
      return [];
    }
  }

  @override
  Future<void> applyForOpportunity({
    required String userId,
    required String userComment,
    required Opportunity opportunity,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'apply_for_opportunity',
        parameters: {
          'user_id': userId,
          'opportunity_id': opportunity.id,
        },
      );

      await _opportunityFeedsRef
          .doc(userId)
          .collection('opportunities')
          .doc(opportunity.id)
          .update({
        'touched': 'like',
        'userComment': userComment,
      });
    } catch (e, s) {
      logger.error('applyForOpporunities', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<void> dislikeOpportunity({
    required Opportunity opportunity,
    required String userId,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'dislike_opportunity',
        parameters: {
          'user_id': userId,
          'opportunity_id': opportunity.id,
        },
      );

      await _opportunityFeedsRef
          .doc(userId)
          .collection('opportunities')
          .doc(opportunity.id)
          .update({
        'touched': 'dislike',
      });
    } catch (e, s) {
      logger.error('applyForOpporunities', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<List<Opportunity>> getOpportunityFeedByUserId(
    String userId, {
    int limit = 20,
    String? lastOpportunityId,
  }) async {
    if (lastOpportunityId != null) {
      final documentSnapshot = await _opportunityFeedsRef
          .doc(userId)
          .collection('opportunities')
          .doc(lastOpportunityId)
          .get();

      final opportunitiesSnapshot = await _opportunityFeedsRef
          .doc(userId)
          .collection('opportunities')
          .orderBy('timestamp', descending: true)
          .where('touched', isNull: true)
          .limit(limit)
          .startAfterDocument(documentSnapshot)
          .get();

      final opportunities =
          opportunitiesSnapshot.docs.map(Opportunity.fromDoc).toList();

      return opportunities;
    }

    final opportunitiesSnapshot = await _opportunityFeedsRef
        .doc(userId)
        .collection('opportunities')
        .orderBy('timestamp', descending: true)
        .where('touched', isNull: true)
        .limit(limit)
        .get();

    final opportunities =
        opportunitiesSnapshot.docs.map(Opportunity.fromDoc).toList();

    return opportunities;
  }

  @override
  Future<int> getUserOpportunityQuota(String userId) async {
    final quotaSnap = await _creditsRef.doc(userId).get();
    final quota = quotaSnap.getOrElse('opportunityQuota', 0);

    return quota;
  }

  @override
  Stream<int> getUserOpportunityQuotaObserver(String userId) async* {
    final quotaSnapObserver = _creditsRef.doc(userId).snapshots();

    final quotaObserver = quotaSnapObserver.map((event) {
      final data = event.data();

      return data?.getOrElse('opportunityQuota', 0) ?? 0;
    });

    yield* quotaObserver;
  }

  @override
  Future<void> decrementUserOpportunityQuota(String userId) async {
    try {
      await _creditsRef.doc(userId).update({
        'opportunityQuota': FieldValue.increment(-1),
      });
    } catch (e, s) {
      logger.error('decrementUserOpportunityQuota', error: e, stackTrace: s);
    }
  }

  @override
  Future<void> blockUser({
    required String currentUserId,
    required String blockedUserId,
  }) async {
    await _analytics.logEvent(
      name: 'block_user',
      parameters: {
        'user_id': currentUserId,
        'blocked_user_id': blockedUserId,
      },
    );

    await _blockerRef
        .doc(currentUserId)
        .collection(blockerSubcollection)
        .doc(blockedUserId)
        .set({
      'timestamp': Timestamp.now(),
    });
  }

  @override
  Future<void> unblockUser({
    required String currentUserId,
    required String blockedUserId,
  }) async {
    await _analytics.logEvent(
      name: 'unblock_user',
      parameters: {
        'user_id': currentUserId,
        'blocked_user_id': blockedUserId,
      },
    );

    await _blockerRef
        .doc(currentUserId)
        .collection(blockerSubcollection)
        .doc(blockedUserId)
        .delete();
  }

  @override
  Future<bool> isBlocked({
    required String blockedUserId,
    required String currentUserId,
  }) async {
    final blockedUserSnapshot = await _blockerRef
        .doc(currentUserId)
        .collection(blockerSubcollection)
        .doc(blockedUserId)
        .get();

    return blockedUserSnapshot.exists;
  }

  @override
  Future<void> reportUser({
    required UserModel reported,
    required UserModel reporter,
  }) async {
    await _analytics.logEvent(
      name: 'report_user',
      parameters: {
        'reporter_id': reporter.id,
        'reported_id': reported.id,
      },
    );
    final reportHtml = '''
        <p>Report from:</p> 
        <p>${reporter.toJson()}<p> 
        <p>User:</p> 
        <p>${reported.toJson()}</p>
    ''';

    await _mailRef.add({
      'to': [
        'support@tapped.ai',
      ],
      'cc': [
        'johannes@tapped.ai',
        'ilias@tapped.ai',
      ],
      'message': {
        'subject': 'User Reported',
        'html': reportHtml,
      },
    });
  }

  @override
  Future<void> createBookerReview(BookerReview review) async {
    await _analytics.logEvent(
      name: 'create_booker_review',
      parameters: {
        'reviewer': review.performerId,
        'reviewee': review.bookerId,
        'type': review.type,
      },
    );

    await _reviewsRef
        .doc(review.bookerId)
        .collection(bookerReviewsSubcollection)
        .doc(review.id)
        .set(review.toMap());
  }

  @override
  Future<void> createPerformerReview(PerformerReview review) async {
    await _analytics.logEvent(
      name: 'create_performer_review',
      parameters: {
        'reviewer': review.bookerId,
        'reviewee': review.performerId,
        'type': review.type,
      },
    );

    await _reviewsRef
        .doc(review.performerId)
        .collection(performerReviewsSubcollection)
        .doc(review.id)
        .set(review.toMap());
  }

  @override
  Future<Option<BookerReview>> getBookerReviewById({
    required String revieweeId,
    required String reviewId,
  }) async {
    try {
      final reviewSnapshot = await _reviewsRef
          .doc(revieweeId)
          .collection(bookerReviewsSubcollection)
          .doc(reviewId)
          .get();
      return reviewSnapshot.exists
          ? Some(BookerReview.fromDoc(reviewSnapshot))
          : const None();
    } catch (e, s) {
      logger.error(
        'error getting booker review by id',
        error: e,
        stackTrace: s,
      );
      return const None();
    }
  }

  @override
  Future<List<BookerReview>> getBookerReviewsByBookerId(
    String bookerId, {
    int limit = 20,
    String? lastReviewId,
  }) async {
    try {
      final reviewsQuery = _reviewsRef
          .doc(bookerId)
          .collection(bookerReviewsSubcollection)
          .orderBy('timestamp', descending: true)
          .limit(limit);

      if (lastReviewId != null) {
        final lastReviewSnapshot = await _reviewsRef
            .doc(bookerId)
            .collection(bookerReviewsSubcollection)
            .doc(lastReviewId)
            .get();
        reviewsQuery.startAfterDocument(lastReviewSnapshot);
      }

      final reviewsSnapshot = await reviewsQuery.get();
      return reviewsSnapshot.docs.map(BookerReview.fromDoc).toList();
    } catch (e, s) {
      logger.error(
        'error getting booker reviews by booker id',
        error: e,
        stackTrace: s,
      );
      return [];
    }
  }

  @override
  Stream<BookerReview> getBookerReviewsByBookerIdObserver(
    String bookerId, {
    int limit = 20,
  }) async* {
    try {
      final reviewsSnapshotObserver = _reviewsRef
          .doc(bookerId)
          .collection(bookerReviewsSubcollection)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .snapshots();

      final reviewsObserver = reviewsSnapshotObserver.map((event) {
        return event.docChanges
            .where(
          (DocumentChange<Map<String, dynamic>> element) =>
              element.type == DocumentChangeType.added,
        )
            .map((DocumentChange<Map<String, dynamic>> element) async {
          final reviewId = element.doc.id;
          // print('REVIEW ID { $reviewId }');

          final reviewSnapshot = await _reviewsRef
              .doc(bookerId)
              .collection(bookerReviewsSubcollection)
              .doc(reviewId)
              .get();

          return BookerReview.fromDoc(reviewSnapshot);
        });
      }).flatMap(Stream.fromIterable);

      await for (final review in reviewsObserver) {
        try {
          yield await review;
        } catch (error, stack) {
          yield* Stream.error(error, stack);
        }
      }
    } catch (e, s) {
      logger.error(
        'error getting booker reviews by booker id',
        error: e,
        stackTrace: s,
      );
      yield* const Stream.empty();
    }
  }

  @override
  Future<Option<PerformerReview>> getPerformerReviewById({
    required String revieweeId,
    required String reviewId,
  }) async {
    try {
      final reviewSnapshot = await _reviewsRef
          .doc(revieweeId)
          .collection(performerReviewsSubcollection)
          .doc(reviewId)
          .get();
      return reviewSnapshot.exists
          ? Some(PerformerReview.fromDoc(reviewSnapshot))
          : const None();
    } catch (e, s) {
      logger.error(
        'error getting performer review by id',
        error: e,
        stackTrace: s,
      );
      return const None();
    }
  }

  @override
  Future<List<PerformerReview>> getPerformerReviewsByPerformerId(
    String performerId, {
    int limit = 20,
    String? lastReviewId,
  }) async {
    try {
      final reviewsQuery = _reviewsRef
          .doc(performerId)
          .collection(performerReviewsSubcollection)
          .orderBy('timestamp', descending: true)
          .limit(limit);

      if (lastReviewId != null) {
        final lastReviewSnapshot = await _reviewsRef
            .doc(performerId)
            .collection(performerReviewsSubcollection)
            .doc(lastReviewId)
            .get();
        reviewsQuery.startAfterDocument(lastReviewSnapshot);
      }

      final reviewsSnapshot = await reviewsQuery.get();
      return reviewsSnapshot.docs.map(PerformerReview.fromDoc).toList();
    } catch (e, s) {
      logger.error(
        'error getting performer reviews by performer id',
        error: e,
        stackTrace: s,
      );
      return [];
    }
  }

  @override
  Stream<PerformerReview> getPerformerReviewsByPerformerIdObserver(
    String performerId, {
    int limit = 20,
  }) async* {
    try {
      final reviewsSnapshotObserver = _reviewsRef
          .doc(performerId)
          .collection(performerReviewsSubcollection)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .snapshots();

      final reviewsObserver = reviewsSnapshotObserver.map((event) {
        return event.docChanges
            .where(
          (DocumentChange<Map<String, dynamic>> element) =>
              element.type == DocumentChangeType.added,
        )
            .map((DocumentChange<Map<String, dynamic>> element) async {
          final reviewId = element.doc.id;
          // print('REVIEW ID { $reviewId }');
          final reviewSnapshot = await _reviewsRef
              .doc(performerId)
              .collection(performerReviewsSubcollection)
              .doc(reviewId)
              .get();

          return PerformerReview.fromDoc(reviewSnapshot);
        });
      }).flatMap(Stream.fromIterable);

      await for (final review in reviewsObserver) {
        try {
          yield await review;
        } catch (error, stack) {
          yield* Stream.error(error, stack);
        }
      }
    } catch (e, s) {
      logger.error(
        'error getting performer reviews by performer id',
        error: e,
        stackTrace: s,
      );
      yield* const Stream.empty();
    }
  }

  @override
  Future<bool> isOnPremiumWailist(String userId) async {
    try {
      final docSnap = await _premiumWailistRef.doc(userId).get();
      return docSnap.exists;
    } catch (e, s) {
      logger.error(
        "can't check if a user is on the waitlist $userId",
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  Future<void> joinPremiumWaitlist(String userId) async {
    try {
      await _premiumWailistRef.doc(userId).set({
        'timestamp': Timestamp.now(),
      });
    } catch (e, s) {
      logger.error(
        "can't add user to the waitlist $userId",
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }
}

class HandleAlreadyExistsException implements Exception {
  HandleAlreadyExistsException(this.cause);
  String cause;
}
