import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

part 'subscription_event.dart';

part 'subscription_state.dart';

const appleApiKey = 'appl_BAFlRDdZwaZXaWiKcgCirDSzGxO';
const googleApiKey = 'goog_JVlZMvIUbaTMKaMHkzFEQXjwXlo';
const entitlementID = 'pro';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc() : super(Uninitialized()) {
    on<CheckSubscriptionStatus>((event, emit) async {
      final currentUserId = event.userId;

      if (kIsWeb) return;

      if (Platform.isIOS || Platform.isMacOS) {
        IapStoreConfig(
          store: Store.appStore,
          apiKey: appleApiKey,
        );
      } else if (Platform.isAndroid) {
        IapStoreConfig(
          store: Store.playStore,
          apiKey: googleApiKey,
        );
      }

      // Enable debug logs before calling `configure`.
      await Purchases.setLogLevel(LogLevel.debug);
      final configuration =
          PurchasesConfiguration(IapStoreConfig.instance.apiKey)
            ..appUserID = currentUserId;
      await Purchases.configure(configuration);

      final customerInfo = await Purchases.getCustomerInfo();
      final subscribed =
          customerInfo.entitlements.active.containsKey(entitlementID);

      emit(
        Initialized(
          customerInfo: customerInfo,
          subscribed: subscribed,
        ),
      );
    });
    on<UpdateSubscription>((event, emit) {
      final customerInfo = event.customerInfo;
      final subscribed =
          customerInfo.entitlements.active.containsKey(entitlementID);
      emit(
        Initialized(
          customerInfo: customerInfo,
          subscribed: subscribed,
        ),
      );
    });
  }
}

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
