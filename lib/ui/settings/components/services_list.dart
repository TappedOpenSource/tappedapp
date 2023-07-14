import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/conditional_parent_widget.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/settings/components/create_service_button.dart';
import 'package:intheloopapp/ui/settings/components/service_card.dart';
import 'package:intheloopapp/ui/settings/settings_cubit.dart';

class ServicesList extends StatelessWidget {
  const ServicesList({
    required this.services,
    required this.isCurrentUser,
    super.key,
  });

  final List<Service> services;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: isCurrentUser ? services.length + 1 : services.length,
            itemBuilder: (context, index) {
              if (index == services.length) {
                return CreateServiceButton(
                  onCreated: context.read<ProfileCubit>().onServiceCreated,
                );
              }

              final service = services[index];

              return ConditionalParentWidget(
                condition: isCurrentUser,
                conditionalBuilder: ({
                  required Widget child,
                }) {
                  return badges.Badge(
                    onTap: () {
                      try {
                        context.push(
                          CreateServicePage(
                            onSubmit: context.read<ProfileCubit>().onServiceEdited,
                            service: Some(service),
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
  }
}
