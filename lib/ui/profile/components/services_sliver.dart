import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/settings/components/services_list.dart';

class ServicesSliver extends StatelessWidget {
  const ServicesSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.services.isEmpty &&
            state.currentUser.id != state.visitedUser.id) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Text(
                      'services',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ServicesList(
                services: state.services,
                isCurrentUser: state.currentUser.id == state.visitedUser.id,
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
