import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/search_repository.dart';
import 'package:intheloopapp/ui/messaging/components/results_list.dart';
import 'package:intheloopapp/ui/messaging/components/search_bar.dart' as search;
import 'package:intheloopapp/ui/messaging/new_chat/new_chat_cubit.dart';

class NewChatView extends StatelessWidget {
  const NewChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewChatCubit(
        database: context.read<DatabaseRepository>(),
        searchRepository: context.read<SearchRepository>(),
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.5,
          title: const search.SearchBar(),
        ),
        body: const Center(
          child: ResultsList(),
        ),
      ),
    );
  }
}
