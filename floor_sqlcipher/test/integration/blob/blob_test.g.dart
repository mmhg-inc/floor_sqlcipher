// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blob_test.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorTestDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$TestDatabaseBuilder databaseBuilder(
    String name, [
    String? password,
  ]) =>
      _$TestDatabaseBuilder(name, password);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$TestDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$TestDatabaseBuilder(null);
}

class _$TestDatabaseBuilder {
  _$TestDatabaseBuilder(
    this.name, [
    this.password,
  ]);

  final String? name;

  final String? password;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$TestDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$TestDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<TestDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$TestDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
      password,
    );
    return database;
  }
}

class _$TestDatabase extends TestDatabase {
  _$TestDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  PersonDao? _personDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
    String? password,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Person` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, `picture` BLOB NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PersonDao get personDao {
    return _personDaoInstance ??= _$PersonDao(database, changeListener);
  }
}

class _$PersonDao extends PersonDao {
  _$PersonDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _personInsertionAdapter = InsertionAdapter(
            database,
            'Person',
            (Person item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'picture': item.picture
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Person> _personInsertionAdapter;

  @override
  Future<Person?> findPersonByPicture(Uint8List picture) async {
    return _queryAdapter.query('SELECT * FROM Person WHERE picture = ?1',
        mapper: (Map<String, Object?> row) => Person(row['id'] as int,
            row['name'] as String, row['picture'] as Uint8List),
        arguments: [picture]);
  }

  @override
  Future<void> insertPerson(Person person) async {
    await _personInsertionAdapter.insert(person, OnConflictStrategy.abort);
  }
}
