import 'dart:async';

import 'package:di/src/di_registration_item.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class DependencyProvider {
  static final GetIt _di = GetIt.instance;

  @visibleForTesting
  static final configurationItems = <DiRegistrationItem>[];

  static bool isRegistered<T extends Object>(
      {Object? instance, String? instanceName}) {
    return _di.isRegistered<T>(instance: instance, instanceName: instanceName);
  }

  static T get<T extends Object>({Type? type, String? instanceName}) {
    return _di.get<T>(instanceName: instanceName, type: type);
  }

  static T? getOrNull<T extends Object>({String? instanceName}) {
    if (isRegistered<T>(instanceName: instanceName)) {
      return get<T>(instanceName: instanceName);
    } else {
      return null;
    }
  }

  static void registerLazySingleton<T extends Object>(T Function() factory,
      {String? instanceName}) {
    _di.registerLazySingleton(factory, instanceName: instanceName);
    configurationItems.add(DiRegistrationItem(T, instanceName: instanceName));
  }

  static void registerFactory<T extends Object>(T Function() factory,
      {String? instanceName}) {
    _di.registerFactory(factory, instanceName: instanceName);
    configurationItems.add(DiRegistrationItem(T, instanceName: instanceName));
  }

  static Future<void> reset() {
    return _di.reset();
  }

  @visibleForTesting
  static FutureOr<void> unRegister<T extends Object>({String? instanceName}) {
    return _di.unregister<T>(instanceName: instanceName);
  }
}
