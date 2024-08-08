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

  @protected
  String get getNewId;
}

class SecureLocalStorage implements BaseStorage {
  final _db = Localstore.instance;
  final String _path = 'todos';

  @override
  String get getNewId => _db.collection(_path).doc().id;

  @override
  Future<void> clear() async {
    try {
      // final data = await getAllValuesInMap();
      // if (data != null) {
      //   for (final element in data.entries) {
      //     await delete(element.key);
      //   }
      // }
      await _db.collection(_path).delete();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> delete(String id) async {
    await _db.collection(_path).doc(id).delete();
  }

  @override
  Future<List<dynamic>> getAll() async {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>?> getAllValuesInMap() async {
    final items = await _db.collection(_path).get();
    return items;
  }

  @override
  Future<dynamic> getByKey(String id, {dynamic defaultValue}) async {
    final data = await _db.collection(_path).doc(id).get();
    return data ?? defaultValue;
  }

  @override
  Future<void> put(String id, Map<String, dynamic> entity) async {
    // save the item
    await _db.collection(_path).doc(id).set(entity);
  }

  @override
  Stream<Map<String, dynamic>> getAllStreamValuesInMap() async* {
    yield* _db.collection(_path).stream.asBroadcastStream();
  }

  @override
  Future<void> update(String id, Map<String, dynamic> entity) async {
    print('Update date:${entity}');
    await _db
        .collection(_path)
        .doc(id)
        .set(entity,SetOptions(merge: true));
  }
}
