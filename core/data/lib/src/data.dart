import 'package:localstore/localstore.dart';

abstract class BaseStorage<T> {
  Future<T?> getByKey(String id, {T? defaultValue});

  Future<void> put(String id, T entity);

  Future<void> delete(String id);

  Future<List<T>> getAll();

  Future<void> clear();

  Future<Map<String, dynamic>?> getAllValuesInMap();

  Stream<Map<String, dynamic>> getAllStreamValuesInMap();
}

class SecureLocalStorage<T> implements BaseStorage<T> {
  final _db = Localstore.instance;
  final String _path = 'todos';

  @override
  Future<void> clear() async {
    try {
      final data = await getAllValuesInMap();
      if (data != null) {
        for (final element in data.entries) {
          await delete(element.key);
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> delete(String id) async {
    await _db.collection(_path).doc(id).delete();
  }

  @override
  Future<List<T>> getAll() async {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>?> getAllValuesInMap() async {
    final items = await _db.collection(_path).get();
    return items;
  }

  @override
  Future<T?> getByKey(String id, {T? defaultValue}) async {
    final data = await _db.collection(_path).doc(id).get();
    return data as T ?? defaultValue;
  }

  @override
  Future<void> put(String id, T entity) async {
    if (T is Map<String, dynamic>) {
      // gets new id
      final id = _db.collection(_path).doc().id;
      // save the item
      await _db.collection(_path).doc(id).set(entity as Map<String, dynamic>);
    } else {
      throw Exception('Type is not supported');
    }
  }

  @override
  Stream<Map<String, dynamic>> getAllStreamValuesInMap() async* {
    yield* _db.collection(_path).stream;
  }
}
