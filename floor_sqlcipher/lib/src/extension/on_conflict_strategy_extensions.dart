import 'package:floor_annotation/floor_annotation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

extension OnConflictStrategyExtensions on OnConflictStrategy {
  ConflictAlgorithm asSqfliteConflictAlgorithm() {
    switch (this) {
      case OnConflictStrategy.replace:
        return ConflictAlgorithm.replace;
      case OnConflictStrategy.rollback:
        return ConflictAlgorithm.rollback;
      case OnConflictStrategy.fail:
        return ConflictAlgorithm.fail;
      case OnConflictStrategy.ignore:
        return ConflictAlgorithm.ignore;
      case OnConflictStrategy.abort:
        return ConflictAlgorithm.abort;
    }
  }
}
