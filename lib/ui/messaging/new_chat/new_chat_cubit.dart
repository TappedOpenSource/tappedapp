import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/search_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

part 'new_chat_state.dart';

class NewChatCubit extends Cubit<NewChatState> {
  NewChatCubit({
    required this.database,
    required this.searchRepository,
  }) : super(NewChatState());

  final DatabaseRepository database;
  final SearchRepository searchRepository;

  void searchUsers(String input) {
    if (input.isNotEmpty) {
      emit(state.copyWith(loading: true, searchTerm: input));
      const duration = Duration(milliseconds: 500);
      Timer(duration, () async {
        if (input == state.searchTerm) {
          // input hasn't changed in the last 500 milliseconds..
          // you can start search
          // print('Now !!! search term : ${state.searchTerm}');
          final searchRes = await searchRepository.queryUsers(state.searchTerm);
          final potentialUsers = await Future.wait(
            searchRes.map(
              (hit) async {
                final user = await database.getUserById(hit.id);
                return user;
              },
            ),
          );
          final users = potentialUsers
              .whereType<Some<UserModel>>()
              .map((e) => e.value)
              .toList();
          // print('RESULTS: $searchRes');
          emit(state.copyWith(searchResults: users, loading: false));
        } else {
          //wait.. Because user still writing..        print('Not Now');
          // print('Not Now');
        }
      });
    }
  }
}
