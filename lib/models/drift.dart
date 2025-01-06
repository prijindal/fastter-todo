import './core.dart';
import './shared.dart';

// this annotation tells drift to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
class MyDatabase {
  static SharedDatabase? _database;

  static SharedDatabase get instance {
    _database ??= constructDb();
    return _database as SharedDatabase;
  }
}
