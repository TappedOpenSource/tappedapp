import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:intheloopapp/data/stream_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
// import 'package:stream_video_flutter/stream_video_flutter.dart' as video;

final _functions = FirebaseFunctions.instance;
final _fireStore = firestore.FirebaseFirestore.instance;
// final streamVideo = video.StreamVideo.instance;

final _usersRef = _fireStore.collection('users');

/// Stream implementation using the stream api
class StreamImpl extends StreamRepository {
  /// clients must provide a stream client to create this impl
  StreamImpl(this._client);

  final StreamChatClient _client;
  bool _connected = false;

  @override
  Future<bool> connectUser(String userId) async {
    logger.debug('connecting user to stream: $userId');
    if (!_connected) {
      logger.debug('user is not already connected to stream...connecting');
      try {
        await _client.disconnectUser();
        final token = await getToken();
        final user = User(id: userId);
        // final userInfo = video.UserInfo(
        //   id: userId,
        //   role: 'admin',
        //   name: 'BLAHBLAH',
        // );
        // await streamVideo.connectUser(userInfo, token);
        await _client.connectUser(user, token);
        _connected = true;
      } catch (e) {
        _connected = false;
      }
    }

    return _connected;
  }

  @override
  Future<List<UserModel>> getChatUsers() async {
    try {
      logger.debug('getting chat users');
      final result = await _client.queryUsers();
      final chatUsers = await Future.wait(
        result.users
            .where((element) => element.id != _client.state.currentUser!.id)
            .map(
          (User e) async {
            final userSnapshot = await _usersRef.doc(e.id).get();
            final user = UserModel.fromDoc(userSnapshot);

            return user;
          },
        ),
      );
      return chatUsers;
    } catch (e, s) {
      logger.error('getChatUser', error: e, stackTrace: s);
      return [];
    }
  }

  @override
  Future<String> getToken() async {
    logger.debug('getting stream token');
    final callable =
        _functions.httpsCallable('ext-auth-chat-getStreamUserToken');

    final results = await callable<String>();
    final token = results.data;

    // print('TOKEN ' + token);
    logger.debug('got stream token $token');

    return token;

    // In Development mode you can just use :
    // return _client.devToken(userId).rawValue;
  }

  @override
  Future<Channel> createGroupChat(
    String id,
    String? name,
    List<String?>? members, {
    String? image,
  }) async {
    var channel = _client.channel('messaging');

    final res = await _client.queryChannelsOnline(
      state: false,
      watch: false,
      filter: Filter.raw(
        value: {
          'members': [
            ...members!,
            _client.state.currentUser!.id,
          ],
          'distinct': true,
        },
      ),
      messageLimit: 0,
      paginationParams: const PaginationParams(
        limit: 1,
      ),
    );

    final channelExisted = res.length == 1;
    if (channelExisted) {
      channel = res.first;
      await channel.watch();
    } else {
      channel = _client.channel(
        'messaging',
        extraData: {
          'name': name,
          'image': image,
          'members': [
            ...members,
            _client.state.currentUser!.id,
          ],
        },
      );
      await channel.watch();
    }

    return channel;
  }

  @override
  Future<Channel> createSimpleChat(String? friendId) async {
    logger.debug(
      'createSimpleChat: ${_client.state.currentUser!.id} + $friendId',
    );
    var channel = _client.channel('messaging');

    final res = await _client.queryChannelsOnline(
      state: false,
      watch: false,
      filter: Filter.raw(
        value: {
          'members': [
            // ..._selectedUsers.map((e) => e.id),
            friendId,
            _client.state.currentUser!.id,
          ],
          'distinct': true,
        },
      ),
      messageLimit: 0,
      paginationParams: const PaginationParams(
        limit: 1,
      ),
    );

    final channelExisted = res.length == 1;
    if (channelExisted) {
      channel = res.first;
      await channel.watch();
    } else {
      channel = _client.channel(
        'messaging',
        extraData: {
          'members': [
            // ..._selectedUsers.map((e) => e.id),
            friendId,
            _client.state.currentUser!.id,
          ],
        },
      );
      await channel.watch();
    }

    return channel;
  }

  // @override
  // video.Call makeVideoCall({
  //   required List<String> participantIds,
  // }) {
  //   final uuid = const Uuid().v4();
  //   final call = streamVideo.makeCall(
  //     type: 'default',
  //     id: uuid,
  //   );

  //   return call;
  // }

  @override
  Future<void> logout() async {
    logger.debug('logout of stream');
    // await streamVideo.disconnectUser();
    return _client.disconnectUser();
  }

  // @override
  // Future<bool> connectIfExist(String userId) async {
  //   final token = await getToken(userId);
  //   await _client.connectUser(
  //     User(id: userId),
  //     token ?? '',
  //   );
  //   return _client.state.currentUser!.id != userId;
  // }
}
