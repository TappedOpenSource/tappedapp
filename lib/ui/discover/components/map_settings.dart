import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/discover/discover_cubit.dart';
import 'package:intheloopapp/ui/settings/components/genre_selection.dart';

class MapSettings extends StatelessWidget {
  const MapSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoverCubit, DiscoverState>(
      builder: (context, state) {
        return Container(
            height: 400,
            width: double.infinity,
            child: Column(
              children: [
                GenreSelection(
                  onConfirm: (genres) {},
                  initialValue: [],
                ),
              ],
            ));
      },
    );
  }
}
