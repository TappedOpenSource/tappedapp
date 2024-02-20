import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/common/waitlist_view.dart';
import 'package:intheloopapp/ui/error/error_view.dart';
import 'package:intheloopapp/ui/loading/logo_wave.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class PaywallView extends StatelessWidget {
  const PaywallView({super.key});

  Widget _buildPackageCard(Package package) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(package.storeProduct.title),
            Text(package.storeProduct.description),
            Text(package.storeProduct.priceString),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: FutureBuilder(
        future: Purchases.getOfferings(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            logger.error(snapshot.error.toString());
            return const ErrorView();
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }

          final offerings = snapshot.data!;
          final offering = offerings.current;
          final packages = offering?.availablePackages ?? [];

          return Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      'assets/splash.gif',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'CREATE A WORLD TOUR FROM YOUR IPHONE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 28,
                        ),
                      ),
                      const Text(
                        'get access to unlimited opportunities and apply to performa at hundreds of venues',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'get full access for \$${packages.first.storeProduct.price} / ${packages.first.packageType.toString().split('.').last.toLowerCase()}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CupertinoButton.filled(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                final package = packages.first;
                                Purchases.purchasePackage(package).then((info) {
                                  logger.info(info.toString());
                                });
                              },
                              child: const Text(
                                'Purchase',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              context.popUntilHome();
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => launchURL(
                              context,
                              'https://tapped.ai/privacy',
                            ),
                            child: const Text(
                              'Privacy',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => launchURL(
                              context,
                              'https://tapped.ai/terms',
                            ),
                            child: const Text(
                              'Terms',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
