flutter pub remove firebase_analytics firebase_app_check firebase_auth firebase_core firebase_crashlytics firebase_storage firebase_ui_auth

rm lib/firebase_options.dart
rm lib/firebase/firebase_init.dart

mv lib/firebase/firebase_init_mocked.dart lib/firebase/firebase_init.dart