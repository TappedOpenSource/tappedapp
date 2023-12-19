import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/data/search_repository.dart';
import 'package:intheloopapp/data/storage_repository.dart';

extension BlocUtils on BuildContext {
  DatabaseRepository get database => read<DatabaseRepository>();
  AuthRepository get auth => read<AuthRepository>();
  StorageRepository get storage => read<StorageRepository>();
  PlacesRepository get places => read<PlacesRepository>();
  SearchRepository get search => read<SearchRepository>();
}
