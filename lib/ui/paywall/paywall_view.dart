import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PaywallView extends StatelessWidget {
  const PaywallView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Purchases.getOfferings(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            logger.error(snapshot.error.toString());
            return const Center(
              child: Text('Error'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }

          final offerings = snapshot.data!;
          final offering = offerings.current;
          final package = offering?.availablePackages.first;
          final product = package?.storeProduct;

          logger..info('ahhhhhhhhhhhh $offerings')
          ..info('bhhhhhhhhhhhh $offering')
          ..info('chhhhhhhhhhhh $package')
          ..info('dhhhhhhhhhhhh $product');

          return Center(
            child: Text(
              product?.priceString ?? 'Que?',
            ),
          );
        },
      ),
    );
  }
}
