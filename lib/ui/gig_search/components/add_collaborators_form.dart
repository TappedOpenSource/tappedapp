import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/common/performer_search_bar.dart';
import 'package:intheloopapp/ui/gig_search/gig_search_cubit.dart';
import 'package:intheloopapp/ui/user_avatar.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

const maxCollaborators = 5;

class AddCollaboratorsForm extends StatelessWidget {
  const AddCollaboratorsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return BlocBuilder<GigSearchCubit, GigSearchState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'recommend a bill',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "you're more likely to get gigs if you're part of a larger bill of performers",
                  ),
                  const SizedBox(height: 16),
                  if (state.collaborators.length >= maxCollaborators)
                    Text(
                      'you can only add up to $maxCollaborators collaborators',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  PerformerSearchBar(
                    onSelected: (user) {
                      if (state.collaborators.length >= maxCollaborators) {
                        return;
                      }

                      if (user.id == currentUser.id) {
                        return;
                      }

                      context.read<GigSearchCubit>().addCollaborator(user);
                    },
                  ),
                  const SizedBox(height: 16),
                  if (state.collaborators.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'bill',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: state.collaborators
                              .map(
                                (collaborator) => Chip(
                                  avatar: UserAvatar(
                                    pushId: Option.of(collaborator.id),
                                    pushUser: Option.of(collaborator),
                                    imageUrl: collaborator.profilePicture,
                                  ),
                                  label: Text(collaborator.displayName),
                                  onDeleted: () {
                                    context
                                        .read<GigSearchCubit>()
                                        .removeCollaborator(
                                          collaborator,
                                        );
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
