import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/common/performer_search_bar.dart';
import 'package:intheloopapp/ui/user_avatar.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class AddCollaboratorsView extends StatefulWidget {
  const AddCollaboratorsView({
    super.key,
    this.maxCollaborators = 5,
    this.onCollaboratorAdded,
    this.onCollaboratorRemoved,
    this.initialCollaborators = const [],
  });

  final int maxCollaborators;
  final void Function(UserModel)? onCollaboratorAdded;
  final void Function(UserModel)? onCollaboratorRemoved;
  final List<UserModel> initialCollaborators;

  @override
  State<AddCollaboratorsView> createState() => _AddCollaboratorsViewState();
}

class _AddCollaboratorsViewState extends State<AddCollaboratorsView> {
  var _collaborators = <UserModel>[];
  int get _maxCollaborators => widget.maxCollaborators;

  @override
  void initState() {
    super.initState();
    _collaborators = List.from(widget.initialCollaborators);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return Scaffold(
          backgroundColor: theme.colorScheme.background,
          appBar: AppBar(),
          body: SafeArea(
            child: Padding(
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
                  if (_collaborators.length >= widget.maxCollaborators)
                    Text(
                      'you can only add up to ${widget.maxCollaborators} collaborators',
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  PerformerSearchBar(
                    onSelected: (user) {
                      if (_collaborators.length >= _maxCollaborators) {
                        return;
                      }

                      if (user.id == currentUser.id) {
                        return;
                      }

                      if (_collaborators.contains(user)) {
                        return;
                      }

                      widget.onCollaboratorAdded?.call(user);
                      setState(() {
                        _collaborators.add(user);
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  if (_collaborators.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
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
                          children: _collaborators
                              .map(
                                (collaborator) => Chip(
                                  avatar: UserAvatar(
                                    pushId: Option.of(collaborator.id),
                                    pushUser: Option.of(collaborator),
                                    imageUrl: collaborator.profilePicture,
                                  ),
                                  label: Text(collaborator.displayName),
                                  onDeleted: () {
                                    widget.onCollaboratorRemoved
                                        ?.call(collaborator);

                                    setState(() {
                                      _collaborators.remove(collaborator);
                                    });
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: CupertinoButton.filled(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          borderRadius: BorderRadius.circular(15),
                          child: const Text(
                            'done',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
