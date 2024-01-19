import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_sqlcipher/sqflite.dart' as sqflite;

// infers factory as nullable without explicit type definition
final sqflite.DatabaseFactory sqfliteDatabaseFactory = () {
  if (Platform.isAndroid || Platform.isIOS) {
    return sqflite.databaseFactory;
  } else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    sqfliteFfiInit();
    return databaseFactoryFfi;
  } else {
    throw UnsupportedError(
      'Platform ${Platform.operatingSystem} is not supported by Floor.',
    );
  }
}();

extension DatabaseFactoryExtension on sqflite.DatabaseFactory {
  Future<String> getDatabasePath(final String name) async {
    final databasesPath = await sqflite.getDatabasesPath();
    return join(databasesPath, name);
  }
}
