import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/badge.dart' as badge;
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/utils/interable_indexed.dart';

class BadgesChip extends StatelessWidget {
  const BadgesChip({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            context.push(
              BadgesPage(
                badges: state.userBadges,
              ),
            );
          },
          child: Stack(
            children: state.userBadges.mapIndexed((
              int index,
              badge.Badge badge,
            ) {
              final offset = index * 20.0;
              return Container(
                margin: EdgeInsets.only(left: offset),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Hero(
                    tag: '${badge.imageUrl}-$index',
                    child: CachedNetworkImage(
                      imageUrl: badge.imageUrl,
                      width: 25,
                      height: 25,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
