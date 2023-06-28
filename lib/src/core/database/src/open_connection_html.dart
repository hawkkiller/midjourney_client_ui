import 'dart:async';

import 'package:database/database.dart';
import 'package:drift/wasm.dart';

FutureOr<AppDatabase> openConnection(String name) async {
  final db = await WasmDatabase.open(
      databaseName: 'my_app_db', // prefer to only use valid identifiers here
      sqlite3Uri: Uri.parse('/sqlite3.wasm'),
      driftWorkerUri: Uri.parse('/drift_worker.dart.js'),
    );

  return AppDatabase(db.resolvedExecutor);
}
