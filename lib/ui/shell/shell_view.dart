import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/domains/subscription_bloc/subscription_bloc.dart';
import 'package:intheloopapp/ui/discover/discover_view.dart';
import 'package:intheloopapp/ui/premium_theme_cubit.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/premium_builder.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class ShellView extends StatelessWidget {
  const ShellView({
    super.key,
  });

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
  }

  @override
  Widget build(BuildContext context) {
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return PremiumBuilder(
          builder: (context, isPremium) {
            context
                .read<PremiumThemeCubit>()
                .updateTheme(isPremiumMode: isPremium);
            return BlocBuilder<NavigationBloc, NavigationState>(
              builder: (context, state) {
                return Scaffold(
                  body: isPremium
                      ? const DiscoverView()
                      : Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              child: ImageFiltered(
                                imageFilter: ImageFilter.blur(
                                  sigmaX: 8,
                                  sigmaY: 8,
                                ),
                                child: const DiscoverView(),
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                height: double.infinity,
                                width: double.infinity,
                                color: Colors.transparent,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CupertinoButton.filled(
                                  // onPressed: () => _onPurchase(
                                  //   context,
                                  //   package: package,
                                  // ),
                                  onPressed: () {
                                    context.push(PaywallPage());
                                  },
                                  borderRadius: BorderRadius.circular(15),
                                  child: const Text(
                                    'unlock trial',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                CupertinoButton(
                                  onPressed: () {
                                    context.authentication.add(LoggedOut());
                                  },
                                  child: Text(
                                    'sign into a different account',
                                    style: TextStyle(
                                      color: Colors.red.withOpacity(0.8),
                                    ),
                                  ),
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
      },
    );
  }
}
