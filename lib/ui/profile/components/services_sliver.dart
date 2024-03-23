import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/conditional_parent_widget.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/settings/components/services_list.dart';

class ServicesSliver extends StatelessWidget {
  const ServicesSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final isCurrentUser = state.currentUser.id == state.visitedUser.id;
        if (state.services.isEmpty && !isCurrentUser) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              ConditionalParentWidget(
                condition: isCurrentUser,
                conditionalBuilder: ({required child}) => GestureDetector(
                  onTap: () {
                    context.push(
                      CreateServicePage(
                        onSubmit: context.read<ProfileCubit>().onServiceCreated,
                        service: const None(),
                      ),
                    );
                  },
                  child: child,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'services',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        CupertinoIcons.add_circled,
                        size: 20,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
              ),
              ServicesList(
                services: state.services,
                isCurrentUser: isCurrentUser,
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
