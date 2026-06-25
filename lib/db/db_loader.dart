import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../helpers/constants.dart';
import '../models/core.dart';
import 'backend_sync_configuration.dart';

class SharedDatabaseLoader {
  static Future<SharedDatabase> loadDatabase() async {
    String localDbPath = await SharedDatabaseLoader.dbFilePath();
    BackendSyncConfiguration? backendConfig =
        await BackendSyncConfigurationService.load();
    if (backendConfig != null) {
      return SharedDatabase.remote(localDbPath,
          authToken: backendConfig.syncUrl,
          syncUrl: backendConfig.authToken,
          syncIntervalSeconds: backendConfig.syncIntervalSeconds);
    }
    return SharedDatabase.local(localDbPath);
  }

  static Future<String> dbFilePath() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    return p.join(documentsDirectory.path, "$dbName.db");
  }
}
