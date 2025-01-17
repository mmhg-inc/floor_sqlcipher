import 'package:floor_sqlcipher/floor.dart';
import 'package:floor_sqlcipher/src/extension/on_conflict_strategy_extensions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

void main() {
  group('asSqfliteConflictAlgorithm', () {
    test('replace', () {
      const onConflictStrategy = OnConflictStrategy.replace;

      final actual = onConflictStrategy.asSqfliteConflictAlgorithm();

      expect(actual, equals(ConflictAlgorithm.replace));
    });

    test('rollback', () {
      const onConflictStrategy = OnConflictStrategy.rollback;

      final actual = onConflictStrategy.asSqfliteConflictAlgorithm();

      expect(actual, equals(ConflictAlgorithm.rollback));
    });

    test('fail', () {
      const onConflictStrategy = OnConflictStrategy.fail;

      final actual = onConflictStrategy.asSqfliteConflictAlgorithm();

      expect(actual, equals(ConflictAlgorithm.fail));
    });

    test('ignore', () {
      const onConflictStrategy = OnConflictStrategy.ignore;

      final actual = onConflictStrategy.asSqfliteConflictAlgorithm();

      expect(actual, equals(ConflictAlgorithm.ignore));
    });

    test('abort', () {
      const onConflictStrategy = OnConflictStrategy.abort;

      final actual = onConflictStrategy.asSqfliteConflictAlgorithm();

      expect(actual, equals(ConflictAlgorithm.abort));
    });
  });
}
