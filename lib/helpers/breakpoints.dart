import 'dart:io';

import 'package:flutter/foundation.dart';

bool get isDesktop {
  if (kIsWeb) return false;
  return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
}

bool get isMobile {
  if (kIsWeb) return false;
  return Platform.isAndroid || Platform.isIOS;
}
