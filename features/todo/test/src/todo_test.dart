// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:todo/todo.dart';

void main() {
  group('Todo', () {
    test('can be instantiated', () {
      expect(Todo(), isNotNull);
    });
  });
}
