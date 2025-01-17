import 'dart:async';

import 'package:floor_sqlcipher/floor.dart';
import 'package:sqflite_sqlcipher/sqflite.dart' as sqflite;

import 'dao/dog_dao.dart';
import 'dao/person_dao.dart';
import 'model/dog.dart';
import 'model/person.dart';

part 'database.g.dart';

@Database(version: 2, entities: [Person, Dog])
abstract class TestDatabase extends FloorDatabase {
  PersonDao get personDao;

  DogDao get dogDao;
}
