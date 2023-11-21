import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/common/easter_egg_placeholder.dart';
import 'package:intheloopapp/ui/common/tapped_app_bar.dart';
import 'package:skeletons/skeletons.dart';

class ServiceSelectionView extends StatelessWidget {
  const ServiceSelectionView({
    required this.userId,
    required this.requesteeStripeConnectedAccountId,
    super.key,
  });

  final String userId;
  final Option<String> requesteeStripeConnectedAccountId;

  void Function()? buildOnTap(BuildContext context, Service service) {
    return switch ((requesteeStripeConnectedAccountId, service.rate)) {
      (_, <= 0) => () => context.push(
            CreateBookingPage(
              service: service,
              requesteeStripeConnectedAccountId: const None(),
            ),
          ),
      (None(), _) => null,
      (Some(:final value), _) => () => context.push(
            CreateBookingPage(
              service: service,
              requesteeStripeConnectedAccountId: Some(value),
            ),
          ),
    };
  }

  Widget _buildListItem(BuildContext context, Service service) => ListTile(
        leading: const Icon(Icons.work),
        title: Text(service.title),
        subtitle: Text(service.description),
        trailing: Text(
          // ignore: lines_longer_than_80_chars
          '\$${(service.rate / 100).toStringAsFixed(2)}${service.rateType == RateType.hourly ? '/hr' : ''}',
          style: const TextStyle(
            color: Colors.green,
          ),
        ),
        onTap: buildOnTap(context, service),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const TappedAppBar(
        title: 'Select Service',
      ),
      body: FutureBuilder<List<Service>>(
        future: context.read<DatabaseRepository>().getUserServices(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SkeletonListView();
          }

          final services = snapshot.data!;
          final sortedServices = services
            ..sort((a, b) => a.rate > b.rate ? 1 : -1);

          if (services.isEmpty) {
            return const Center(
              child: EasterEggPlaceholder(
                text: 'No services found',
              ),
            );
          }

          return ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = sortedServices[index];

              return switch ((
                requesteeStripeConnectedAccountId,
                service.rate
              )) {
                (_, <= 0) => _buildListItem(context, service),
                (Some(), _) => _buildListItem(context, service),
                (None(), _) => Stack(
                    children: [
                      _buildListItem(context, service),
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                      const Positioned.fill(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: 24,
                            ),
                            Text("artist's payment info isn't connected"),
                          ],
                        ),
                      ),
                    ],
                  ),
              };
            },
          );
        },
      ),
    );
  }
}
