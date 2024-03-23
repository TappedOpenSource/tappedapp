import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/conditional_parent_widget.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/settings/components/create_service_button.dart';
import 'package:intheloopapp/ui/settings/components/service_card.dart';
import 'package:intheloopapp/utils/admin_builder.dart';

class ServicesList extends StatelessWidget {
  const ServicesList({
    required this.services,
    required this.isCurrentUser,
    super.key,
  });

  final List<Service> services;
  final bool isCurrentUser;

  Widget _customBookingButton(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {},
          child: Card(
            elevation: 0,
            color: theme.colorScheme.onSurface.withOpacity(0.1),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              width: 190,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.work,
                      size: 50,
                      // color: Colors.blue,
                    ),
                    const Text(
                      'custom booking',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        // color: Colors.blue,
                      ),
                    ),
                    CupertinoButton(
                      onPressed: () => context.push(
                        CreateBookingPage(
                          requesteeId: state.visitedUser.id,
                          service: const None(),
                          requesteeStripeConnectedAccountId:
                              state.visitedUser.stripeConnectedAccountId,
                        ),
                      ),
                      child: const Text('book now'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminBuilder(
      builder: (context, isAdmin) {
        return Column(
          children: [
            SizedBox(
              height: 190,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:
                    isCurrentUser ? services.length : services.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0 && !isCurrentUser) {
                    return _customBookingButton(context);
                  }

                  final listIndex = isCurrentUser ? index : index - 1;
                  final service = services[listIndex];
                  return ConditionalParentWidget(
                    condition: isCurrentUser || isAdmin,
                    conditionalBuilder: ({
                      required Widget child,
                    }) {
                      return badges.Badge(
                        onTap: () {
                          try {
                            context.push(
                              CreateServicePage(
                                onSubmit: context
                                    .read<ProfileCubit>()
                                    .onServiceEdited,
                                service: Option.of(service),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.red,
                                content: Text('Error editing service'),
                              ),
                            );
                          }
                        },
                        badgeStyle: const badges.BadgeStyle(
                          badgeColor: Color.fromARGB(255, 47, 47, 47),
                        ),
                        badgeContent: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 25,
                        ),
                        child: child,
                      );
                    },
                    child: ServiceCard(
                      service: service,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
