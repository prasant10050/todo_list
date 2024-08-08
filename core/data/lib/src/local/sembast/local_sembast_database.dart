import 'dart:async';

import 'package:data/data.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/utils/value_utils.dart';
import 'package:sembast_web/sembast_web.dart';

class LocalSembastDatabase {
  // A private constructor. Allows us to create instances of LocalSembastDatabase
  // only from within the LocalSembastDatabase class itself.
  LocalSembastDatabase._();

  // Singleton instance
  static final LocalSembastDatabase _singleton = LocalSembastDatabase._();

  // Singleton accessor
  static LocalSembastDatabase get instance => _singleton;

  // Completer is used for transforming synchronous code into asynchronous code.
  Completer<Database>? _dbOpenCompleter;

  bool isInitialized = false;
  var _todo = StoreRef<String, Map<String, dynamic>>('todo');

  StoreRef<String, Map<String, dynamic>> get todo => _todo;

  //var factory = databaseFactoryWeb;
  // Database object accessor
  Future<Database> get database async {
    // If completer is null, LocalSembastDatabaseClass is newly instantiated, so database is not yet opened
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      // Calling _openDatabase will also complete the completer with database instance
      await _openDatabase();
    }
    // If the database is already opened, awaiting the future will happen instantly.
    // Otherwise, awaiting the returned future will take some time - until complete() is called
    // on the Completer in _openDatabase() below.
    return _dbOpenCompleter!.future;
  }

  Future<void> _openDatabase() async {
    // Get a platform-specific directory where persistent app data can be stored
    final appDocumentDir = await getApplicationDocumentsDirectory();
    // Path with the form: /platform-specific-directory/demo.db
    final dbPath = join(appDocumentDir.path, 'todo.db');
    _todo = StoreRef<String, Map<String, dynamic>>('todo');
    Database database;
    if (kIsWeb) {
      final factory = databaseFactoryWeb;
      database = await factory.openDatabase(dbPath);
    } else {
      database = await databaseFactoryIo.openDatabase(dbPath);
    }
    isInitialized = true;
    // Any code awaiting the Completer's future will now start executing
    _dbOpenCompleter?.complete(database);
  }
}

class LocalSembastDataDao implements BaseStorage {
  Future<Database> get _db async => LocalSembastDatabase.instance.database;

  StoreRef<String, Map<String, dynamic>> get _todoStore =>
      LocalSembastDatabase.instance.todo;

  @override
  Future<void> clear() async {
    final db = await _db;
    await db.transaction((transaction) async {
      // Delete all
      await _todoStore.delete(transaction);
    });
    await _todoStore.delete(await _db);
  }

  @override
  Future<void> delete(String id) async {
    await _todoStore.record(id).delete(await _db);
  }

  @override
  Future<List<Map<String, dynamic>>> getAll() async {
    final records = await _todoStore.find(await _db);
    final data = <Map<String, dynamic>>[];
    records.map((snapshot) {
      final todo = snapshot.value;
      data.add(MapEntry(snapshot.key, todo) as Map<String, dynamic>);
    });
    return data;
  }

  @override
  Stream<Map<String, dynamic>> getAllStreamValuesInMap() async* {
    final data = <String, dynamic>{};
    _todoStore.query().onSnapshots(await _db).map((snapshots) {
      return snapshots.map((snapshot) {
        final todo = snapshot.value;
        data.putIfAbsent(
          snapshot.key,
          () => todo,
        );
      }).toList();
    });
    yield data;
  }

  @override
  Future<Map<String, dynamic>?> getAllValuesInMap() async {
    final records = await _todoStore.find(await _db);
    final data = <String, dynamic>{};
    records.map((snapshot) {
      final todo = snapshot.value;
      return data.putIfAbsent(
        snapshot.key,
        () => todo,
      );
    }).toList();
    return data;
  }

  @override
  Future<dynamic> getByKey(String id, {dynamic defaultValue}) async {
    final record = await _todoStore.record(id).get(await _db);
    return record ?? defaultValue;
  }

  @override
  // TODO: implement getNewId
  String get getNewId => throw UnimplementedError();

  @override
  Future<void> put(String id, Map<String, dynamic> entity) async {
    await _todoStore.record(id).put(
          await _db,
          entity,
          merge: false,
          ifNotExists: true,
        );
  }

  @override
  Future<void> update(String id, Map<String, dynamic> entity) async {
    final value=await getByKey(id) as Map<String,dynamic>;
    var map = cloneMap(value);
    map=entity;
    await _todoStore.record(id).put(await _db, map, merge: true);
    final updatedRecord=await getByKey(id) as Map<String,dynamic>;
    print('Updated record: $updatedRecord');
  }
}
