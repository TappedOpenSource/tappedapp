import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/common/tapped_app_bar.dart';
import 'package:intheloopapp/ui/error/error_view.dart';
import 'package:intheloopapp/ui/profile/components/request_to_book.dart';
import 'package:intheloopapp/ui/user_tile.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class ServiceView extends StatelessWidget {
  const ServiceView({
    required this.service,
    required this.serviceUser,
    super.key,
  });

  final Service service;
  final Option<UserModel> serviceUser;

  Widget _editServiceButton(BuildContext context) {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton(
        onPressed: () {
          context
            ..pop()
            ..push(
              CreateServicePage(
                onSubmit: (Service service) {},
                service: Some(service),
              ),
            );
        },
        borderRadius: BorderRadius.circular(15),
        color: onSurfaceColor.withOpacity(0.1),
        child: Text(
          'Edit Service',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: onSurfaceColor,
          ),
        ),
      ),
    );
  }

  Widget _deleteServiceButton(BuildContext context) {
    final database = context.database;
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton(
        onPressed: () async {
          context.pop();
          await database.deleteService(service.userId, service.id);
        },
        borderRadius: BorderRadius.circular(15),
        child: const Text(
          'Delete Service',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final database = context.database;
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return Scaffold(
          backgroundColor: theme.colorScheme.background,
          appBar: const TappedAppBar(
            title: 'Service',
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 14,
                  ),
                  UserTile(userId: service.userId, user: serviceUser),
                  const SizedBox(
                    height: 22,
                  ),
                  Text(
                    service.title,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Text(
                    '\$${(service.rate / 100).toStringAsFixed(2)}${service.rateType == RateType.hourly ? '/hr' : ''}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Text(
                    service.description,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  if (currentUser.id == service.userId)
                    _editServiceButton(context)
                  else
                    FutureBuilder<Option<UserModel>>(
                      future: database.getUserById(service.userId),
                      builder: (context, snapshot) {
                        final data = snapshot.data;
                        return switch (data) {
                          null => const CupertinoActivityIndicator(),
                          None() => const ErrorView(),
                          Some(:final value) => () {
                              return SizedBox(
                                width: double.infinity,
                                child: RequestToBookButton(
                                  userId: service.userId,
                                  service: Some(service),
                                  stripeConnectedAccountId: Option.fromNullable(
                                    value.stripeConnectedAccountId,
                                  ),
                                ),
                              );
                            }(),
                        };
                      },
                    ),
                  if (currentUser.id == service.userId)
                    _deleteServiceButton(
                      context,
                    ),
                  const SizedBox(
                    height: 34,
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
