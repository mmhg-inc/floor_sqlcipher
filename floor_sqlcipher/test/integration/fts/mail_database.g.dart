// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mail_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorMailDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$MailDatabaseBuilder databaseBuilder(
    String name, [
    String? password,
  ]) =>
      _$MailDatabaseBuilder(name, password);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$MailDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$MailDatabaseBuilder(null);
}

class _$MailDatabaseBuilder {
  _$MailDatabaseBuilder(
    this.name, [
    this.password,
  ]);

  final String? name;

  final String? password;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$MailDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$MailDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<MailDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$MailDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
      password,
    );
    return database;
  }
}

class _$MailDatabase extends MailDatabase {
  _$MailDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  MailDao? _mailDaoInstance;

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
            'CREATE VIRTUAL TABLE IF NOT EXISTS `mail` USING fts4(`rowid` INTEGER NOT NULL, `text` TEXT NOT NULL, PRIMARY KEY (`rowid`), tokenize=unicode61 )');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  MailDao get mailDao {
    return _mailDaoInstance ??= _$MailDao(database, changeListener);
  }
}

class _$MailDao extends MailDao {
  _$MailDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _mailInsertionAdapter = InsertionAdapter(
            database,
            'mail',
            (Mail item) =>
                <String, Object?>{'rowid': item.id, 'text': item.text},
            changeListener),
        _mailUpdateAdapter = UpdateAdapter(
            database,
            'mail',
            ['rowid'],
            (Mail item) =>
                <String, Object?>{'rowid': item.id, 'text': item.text},
            changeListener),
        _mailDeletionAdapter = DeletionAdapter(
            database,
            'mail',
            ['rowid'],
            (Mail item) =>
                <String, Object?>{'rowid': item.id, 'text': item.text},
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Mail> _mailInsertionAdapter;

  final UpdateAdapter<Mail> _mailUpdateAdapter;

  final DeletionAdapter<Mail> _mailDeletionAdapter;

  @override
  Future<Mail?> findMailById(int id) async {
    return _queryAdapter.query('SELECT * FROM mail WHERE rowid = ?1',
        mapper: (Map<String, Object?> row) =>
            Mail(row['rowid'] as int, row['text'] as String),
        arguments: [id]);
  }

  @override
  Future<List<Mail>> findMailByKey(String key) async {
    return _queryAdapter.queryList('SELECT * FROM mail WHERE text match ?1',
        mapper: (Map<String, Object?> row) =>
            Mail(row['rowid'] as int, row['text'] as String),
        arguments: [key]);
  }

  @override
  Future<List<Mail>> findAllMails() async {
    return _queryAdapter.queryList('SELECT * FROM mail',
        mapper: (Map<String, Object?> row) =>
            Mail(row['rowid'] as int, row['text'] as String));
  }

  @override
  Stream<List<Mail>> findAllMailsAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM mail',
        mapper: (Map<String, Object?> row) =>
            Mail(row['rowid'] as int, row['text'] as String),
        queryableName: 'mail',
        isView: false);
  }

  @override
  Future<void> insertMail(Mail mailInfo) async {
    await _mailInsertionAdapter.insert(mailInfo, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertMails(List<Mail> mailInfo) async {
    await _mailInsertionAdapter.insertList(mailInfo, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateMail(Mail mailInfo) async {
    await _mailUpdateAdapter.update(mailInfo, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateMails(List<Mail> mailInfo) async {
    await _mailUpdateAdapter.updateList(mailInfo, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteMail(Mail mailInfo) async {
    await _mailDeletionAdapter.delete(mailInfo);
  }

  @override
  Future<void> deleteMails(List<Mail> mailInfo) async {
    await _mailDeletionAdapter.deleteList(mailInfo);
  }
}
