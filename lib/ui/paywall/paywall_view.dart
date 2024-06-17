import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/subscription_bloc/subscription_bloc.dart';
import 'package:intheloopapp/ui/loading/logo_wave.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/premium_builder.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class PaywallView extends StatelessWidget {
  const PaywallView({
    super.key,
  });

  // Widget _buildPackageCard(Package package) {
  //   return Card(
  //     child: Padding(
  //       padding: const EdgeInsets.all(20),
  //       child: Column(
  //         children: [
  //           Text(package.storeProduct.title),
  //           Text(package.storeProduct.description),
  //           Text(package.storeProduct.priceString),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildCheckItem({required String text}) {
    return Row(
      children: [
        SizedBox(
          height: 45,
          width: 45,
          child: Icon(
            Icons.check_circle,
            color: Colors.green.withOpacity(0.5),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onPurchase(
    BuildContext context, {
    required Package package,
  }) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final subscriptions = context.subscriptions;
    final nav = context.nav;

    await HapticFeedback.lightImpact();
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    try {
      final customerInfo = await Purchases.purchasePackage(
        package,
      );
      subscriptions.add(
        UpdateSubscription(
          customerInfo: customerInfo,
        ),
      );

      logger.info(customerInfo.toString());
    } catch (error, s) {
      logger.error('error purchasing package', error: error, stackTrace: s);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: const Text(
            'purchase canceled',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    await EasyLoading.dismiss();
    nav.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PremiumBuilder(
      builder: (context, isPremium) {
        if (isPremium) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const LogoWave(),
                  const SizedBox(height: 20),
                  const Text(
                    'You are already a premium member',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: CupertinoButton.filled(
                          onPressed: () {
                            context.pop();
                          },
                          borderRadius: BorderRadius.circular(15),
                          child: const Text(
                            'Okay',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }

        return FutureBuilder(
          future: Purchases.getOfferings(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              logger.error(
                'error fetching offerings',
                error: snapshot.error,
                stackTrace: snapshot.stackTrace,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  content: const Text(
                    'error fetching offerings',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }

            final offerings = snapshot.data;

            if (offerings == null) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }

            final offering = offerings.current;
            final packages = offering?.availablePackages ?? [];
            final package = packages.where((element) {
              return element.packageType == PackageType.monthly;
            }).first;

            return Scaffold(
              backgroundColor: theme.colorScheme.surface,
              bottomNavigationBar: Container(
                color: theme.colorScheme.surface,
                height: 150,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Text(
                      'get full access for \$${package.storeProduct.price.toStringAsFixed(2)} / ${package.packageType.toString().split('.').last.toLowerCase()}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CupertinoButton.filled(
                            onPressed: () => _onPurchase(
                              context,
                              package: package,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            child: const Text(
                              'Purchase',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
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
                            context.pop();
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => launchURL(
                            context,
                            'https://app.tapped.ai/privacy',
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
                            'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/',
                          ),
                          child: const Text(
                            'terms',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   height: 30,
                    // ),                       // SizedBox(
                    //   height: 30,
                    // ),
                  ],
                ),
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.3,
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
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 20,
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
                              const SizedBox(height: 12),
                              _buildCheckItem(
                                text: 'unlimited gig opportunities',
                              ),
                              const SizedBox(height: 12),
                              _buildCheckItem(
                                text:
                                    'exclusive info on venues looking for performers',
                              ),
                              const SizedBox(height: 12),
                              _buildCheckItem(
                                text: 'contact info for thousands of venues',
                              ),
                              const SizedBox(height: 12),
                              _buildCheckItem(
                                text: 'advanced search',
                              ),
                              // const Spacer(),
                              // Text(
                              //   'get full access for \$${package.storeProduct.price.toStringAsFixed(2)} / ${package.packageType.toString().split('.').last.toLowerCase()}',
                              //   textAlign: TextAlign.center,
                              //   style: const TextStyle(
                              //     color: Colors.grey,
                              //   ),
                              // ),
                              // const SizedBox(height: 4),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     Expanded(
                              //       child: CupertinoButton.filled(
                              //         onPressed: () => _onPurchase(
                              //           context,
                              //           package: package,
                              //         ),
                              //         borderRadius: BorderRadius.circular(15),
                              //         child: const Text(
                              //           'Purchase',
                              //           style: TextStyle(
                              //             fontWeight: FontWeight.bold,
                              //             color: Colors.white,
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // const SizedBox(height: 2),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     TextButton(
                              //       onPressed: () {
                              //         context.pop();
                              //       },
                              //       child: const Text(
                              //         'Cancel',
                              //         style: TextStyle(
                              //           color: Colors.red,
                              //         ),
                              //       ),
                              //     ),
                              //     TextButton(
                              //       onPressed: () => launchURL(
                              //         context,
                              //         'https://app.tapped.ai/privacy',
                              //       ),
                              //       child: const Text(
                              //         'Privacy',
                              //         style: TextStyle(
                              //           color: Colors.grey,
                              //         ),
                              //       ),
                              //     ),
                              //     TextButton(
                              //       onPressed: () => launchURL(
                              //         context,
                              //         'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/',
                              //       ),
                              //       child: const Text(
                              //         'terms',
                              //         style: TextStyle(
                              //           color: Colors.grey,
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Positioned(
                  //   bottom: 0,
                  //   left: 0,
                  //   child: Container(
                  //     // color: theme.colorScheme.surface,
                  //     color: Colors.green,
                  //     child: Column(
                  //       children: [
                  //         Text(
                  //           'get full access for \$${package.storeProduct.price.toStringAsFixed(2)} / ${package.packageType.toString().split('.').last.toLowerCase()}',
                  //           textAlign: TextAlign.center,
                  //           style: const TextStyle(
                  //             color: Colors.grey,
                  //           ),
                  //         ),
                  //         const SizedBox(height: 4),
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Expanded(
                  //               child: CupertinoButton.filled(
                  //                 onPressed: () => _onPurchase(
                  //                   context,
                  //                   package: package,
                  //                 ),
                  //                 borderRadius: BorderRadius.circular(15),
                  //                 child: const Text(
                  //                   'Purchase',
                  //                   style: TextStyle(
                  //                     fontWeight: FontWeight.bold,
                  //                     color: Colors.white,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         const SizedBox(height: 2),
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             TextButton(
                  //               onPressed: () {
                  //                 context.pop();
                  //               },
                  //               child: const Text(
                  //                 'Cancel',
                  //                 style: TextStyle(
                  //                   color: Colors.red,
                  //                 ),
                  //               ),
                  //             ),
                  //             TextButton(
                  //               onPressed: () => launchURL(
                  //                 context,
                  //                 'https://app.tapped.ai/privacy',
                  //               ),
                  //               child: const Text(
                  //                 'Privacy',
                  //                 style: TextStyle(
                  //                   color: Colors.grey,
                  //                 ),
                  //               ),
                  //             ),
                  //             TextButton(
                  //               onPressed: () => launchURL(
                  //                 context,
                  //                 'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/',
                  //               ),
                  //               child: const Text(
                  //                 'terms',
                  //                 style: TextStyle(
                  //                   color: Colors.grey,
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         // SizedBox(
                  //         //   height: 30,
                  //         // ),                       // SizedBox(
                  //         //   height: 30,
                  //         // ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
