import 'package:flutter/foundation.dart';
import 'package:localstore/localstore.dart';

abstract class BaseStorage {
  Future<dynamic> getByKey(String id, {dynamic defaultValue});

  Future<dynamic> put(String id, Map<String, dynamic> entity);

  Future<void> delete(String id);

  Future<List<dynamic>> getAll();

  Future<void> clear();

  Future<Map<String, dynamic>?> getAllValuesInMap();

  Stream<Map<String, dynamic>> getAllStreamValuesInMap();

  Future<void> update(String id, Map<String, dynamic> entity);
}
