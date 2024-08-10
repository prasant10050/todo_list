import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sembast/sembast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:data/data.dart';

class MockDatabase extends Mock implements Database {}

class MockTransaction extends Mock implements Transaction {}

class MockStoreRef extends Mock implements StoreRef<String, Map<String, dynamic>> {}

class MockRecordRef extends Mock implements RecordRef<String, Map<String, dynamic>> {}

void main() {
  late MockDatabase mockDatabase;
  late MockTransaction mockTransaction;
  late MockStoreRef mockStoreRef;
  late LocalSembastDataDao localSembastDataDao;

  setUp(() {
    mockDatabase = MockDatabase();
    mockTransaction = MockTransaction();
    mockStoreRef = MockStoreRef();
    localSembastDataDao = LocalSembastDataDao();
  });

  test('clear should delete all records', () async {
    when(() => mockStoreRef.delete(mockTransaction)).thenAnswer((_) async => 0);
    when(() => mockDatabase.transaction(any())).thenAnswer((invocation) async {
      final action = invocation.positionalArguments[0] as Future<void> Function(Transaction);
      await action(mockTransaction);
      return;
    });

    await localSembastDataDao.clear();

    verify(() => mockStoreRef.delete(mockTransaction)).called(1);
  });

  test('delete should delete record by id', () async {
    final mockRecordRef = MockRecordRef();
    when(() => mockStoreRef.record('test_id')).thenReturn(mockRecordRef);
    when(() => mockRecordRef.delete(mockDatabase)).thenAnswer((_) async => null);

    await localSembastDataDao.delete('test_id');

    verify(() => mockStoreRef.record('test_id')).called(1);
    verify(() => mockRecordRef.delete(mockDatabase)).called(1);
  });

  test('put should save a record with the given id and entity', () async {
    final mockRecordRef = MockRecordRef();
    final entity = {'key': 'value'};

    when(() => mockStoreRef.record('test_id')).thenReturn(mockRecordRef);
    when(() => mockRecordRef.put(mockDatabase, entity, merge: false, ifNotExists: true))
        .thenAnswer((_) async => {});

    await localSembastDataDao.put('test_id', entity);

    verify(() => mockStoreRef.record('test_id')).called(1);
    verify(() => mockRecordRef.put(mockDatabase, entity, merge: false, ifNotExists: true)).called(1);
  });

  /*test('getAll should return all records', () async {
    final records = <RecordSnapshot<String, Map<String, dynamic>>>[
      RecordSnapshot('test_id_1', {'key': 'value'}),
      RecordSnapshot('test_id_2', {'key': 'value2'}),
    ];

    when(() => mockStoreRef.find(mockDatabase)).thenAnswer((_) async => records);

    final result = await localSembastDataDao.getAll();

    expect(result.length, 2);
    expect(result[0]['key'], 'value');
    expect(result[1]['key'], 'value2');
  });*/

  // Add more test cases based on other methods.
}
