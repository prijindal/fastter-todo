import 'package:auto_route/auto_route.dart';
import 'package:fastter_todo/models/db_manager.dart';
import 'package:fastter_todo/models/local_db_state.dart';
import 'package:fastter_todo/models/local_state.dart';
import 'package:fastter_todo/models/settings.dart';
import 'package:fastter_todo/pages/todos/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockStackRouter extends Mock implements StackRouter {}

class FakePageRouteInfo extends Fake implements PageRouteInfo {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());
  });
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('Create a todo and verify that it got created', (tester) async {
      final mockStackRouter = MockStackRouter();
      when(() => mockStackRouter.pushNamed(any())).thenAnswer((_) async {
        return null;
      });
      when(() => mockStackRouter.currentUrl).thenReturn('/todos');
      // Load app widget.
      var dbManager = DbManager.localOnly();
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<DbManager>(
              create: (context) => dbManager,
            ),
            ChangeNotifierProvider<SettingsStorageNotifier>(
              create: (context) => SettingsStorageNotifier(),
            ),
            ChangeNotifierProvider<LocalStateNotifier>(
              create: (_) => LocalStateNotifier(),
            ),
            ChangeNotifierProvider<LocalDbState>(
              create: (_) => LocalDbState(dbManager.database),
            ),
          ],
          child: MaterialApp(
            title: 'Routing Test',
            home: StackRouterScope(
              controller: mockStackRouter,
              stateHash: 0,
              child: TodosScreen(),
            ),
          ),
        ),
      );

      // Verify the counter starts at 0.
      expect(find.text('All Todos'), findsAtLeastNWidgets(1));

      // Finds the floating action button to tap on.
      final fab = find.byKey(const ValueKey('New Todo'));

      // Emulate a tap on the floating action button.
      debugPrint("Tapping on the FAB");
      await tester.tap(fab);
      await tester.pumpAndSettle();

      final todoInput = find.byKey(const ValueKey("TodoInputBarTitleForm"));

      expect(todoInput, findsOneWidget);

      debugPrint("Entering text on form");
      await tester.enterText(todoInput, "A Sample todo");
      await tester.pumpAndSettle();

      final addIcon = find.byKey(const ValueKey("TodoInputBarSendButton"));

      debugPrint("Tapping add icon button");
      await tester.tap(addIcon);
      await tester.pumpAndSettle();
    });
  });
}
