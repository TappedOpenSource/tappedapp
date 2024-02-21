import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';


const appleApiKey = 'appl_BAFlRDdZwaZXaWiKcgCirDSzGxO';
const googleApiKey = 'goog_JVlZMvIUbaTMKaMHkzFEQXjwXlo';
const entitlementID = 'pro';

class IapStoreConfig {
  factory IapStoreConfig({required Store store, required String apiKey}) {
    _instance ??= IapStoreConfig._internal(store, apiKey);
    return _instance!;
  }

  IapStoreConfig._internal(this.store, this.apiKey);
  final Store store;
  final String apiKey;
  static IapStoreConfig? _instance;

  static IapStoreConfig get instance {
    return _instance!;
  }

  static bool isForAppleStore() => instance.store == Store.appStore;
  static bool isForGooglePlay() => instance.store == Store.playStore;
}

Future<void> configureIapSdk(String currentUserId) async {
  if (kIsWeb) return;

  if (Platform.isIOS || Platform.isMacOS) {
    IapStoreConfig(
      store: Store.appStore,
      apiKey: appleApiKey,
    );
  } else if (Platform.isAndroid) {
    // Run the app passing --dart-define=AMAZON=true
    IapStoreConfig(
      store: Store.playStore,
      apiKey: googleApiKey,
    );
  }

  // Enable debug logs before calling `configure`.
  await Purchases.setLogLevel(LogLevel.debug);

  /*
    - appUserID is nil, so an anonymous ID will be generated automatically by the Purchases SDK. Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids

    - observerMode is false, so Purchases will automatically handle finishing transactions. Read more about Observer Mode here: https://docs.revenuecat.com/docs/observer-mode
    */
  PurchasesConfiguration configuration;

  configuration = PurchasesConfiguration(IapStoreConfig.instance.apiKey)
    ..appUserID = currentUserId
    ..observerMode = false;
  await Purchases.configure(configuration);
}
