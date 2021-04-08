// @dart=2.9
import 'package:flutter/material.dart';

///To run this integration test, use following command:
/// flutter drive --target=integration_test/app_test.dart --driver=test_driver/integration_test.dart
///ref = https://flutter.dev/docs/testing/integration-tests
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:todo_provider/app.dart';
import 'package:todo_provider/common/todos_app_core/todos_app_core.dart';
import 'package:todo_provider/common/todos_repository_core/mock_repository.dart';
import 'package:todo_provider/sceens/add_todo/add_todo_screen.dart';
import 'package:todo_provider/sceens/details/details_screen.dart';
import 'package:todo_provider/sceens/edit/edit_todo_screen.dart';
import 'package:todo_provider/sceens/home/home_screen.dart';
import 'package:todo_provider/sceens/home/stats_view.dart';
import 'package:todo_provider/sceens/home/todo_list_view.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Todo App Test', () {
    testWidgets('should show a loading screen while the todos are fetched',
        (tester) async {
      await tester.pumpApp(settle: false);
      expect(find.byKey(ArchSampleKeys.todosLoading), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('should start with a list of Todos', (tester) async {
      await tester.pumpApp();
      expect(find.text('Todo Provider'), findsOneWidget);
      expect(find.text('T1'), findsOneWidget);
      expect(find.text('T2'), findsOneWidget);
      expect(find.text('T3'), findsOneWidget);
    });

    testWidgets('navigate to Stat and List', (tester) async {
      await tester.pumpApp();

      await tester.tap(find.byKey(ArchSampleKeys.statsTab));
      await tester.pumpAndSettle();

      expect(find.byType(StatsView), findsOneWidget);

      await tester.tap(find.byKey(ArchSampleKeys.todoTab));
      await tester.pumpAndSettle();

      expect(find.byType(TodoListView), findsOneWidget);
    });

    testWidgets('navigate to Add', (tester) async {
      await tester.pumpApp();

      await tester.tap(find.byKey(ArchSampleKeys.addTodoFab));
      await tester.pumpAndSettle();

      expect(find.byType(AddTodoScreen), findsOneWidget);
    });

    testWidgets('should be able to click on an item to see details',
        (tester) async {
      await tester.pumpApp();

      await tester.tap(find.text('T1'));
      await tester.pumpAndSettle();

      expect(find.byType(DetailsScreen), findsOneWidget);
    });

    testWidgets('should be able to delete a todo on the details screen',
        (tester) async {
      await tester.pumpApp();

      await tester.tap(find.text('T1'));
      await tester.pumpAndSettle();

      expect(find.byType(DetailsScreen), findsOneWidget);

      await tester.tap(find.byKey(ArchSampleKeys.deleteTodoButton));
      await tester.pumpAndSettle();

      expect(find.text('T1'), findsNothing,
          reason: 'TodoItem T1 should be absent');
      expect(find.text('T2'), findsOneWidget);
      expect(find.text('T3'), findsOneWidget);
      expect(find.byKey(ArchSampleKeys.snackbar), findsOneWidget,
          reason: 'snackbar should be visible');
    });

    testWidgets('should filter to completed todos', (tester) async {
      await tester.pumpApp();
      await tester.tap(find.byKey(ArchSampleKeys.filterButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(ArchSampleKeys.completedFilter));
      await tester.pumpAndSettle();

      expect(find.text('T1'), findsNothing);
      expect(find.text('T2'), findsNothing);
      expect(find.text('T3'), findsOneWidget);
    });

    testWidgets('should filter to active todos', (tester) async {
      await tester.pumpApp();
      await tester.tap(find.byKey(ArchSampleKeys.filterButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(ArchSampleKeys.activeFilter));
      await tester.pumpAndSettle();

      expect(find.text('T1'), findsOneWidget);
      expect(find.text('T2'), findsOneWidget);
      expect(find.text('T3'), findsNothing);
    });

    testWidgets('should once again filter to all todos', (tester) async {
      await tester.pumpApp();
      await tester.tap(find.byKey(ArchSampleKeys.filterButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(ArchSampleKeys.allFilter));
      await tester.pumpAndSettle();

      expect(find.text('T1'), findsOneWidget);
      expect(find.text('T2'), findsOneWidget);
      expect(find.text('T3'), findsOneWidget);
    });

    testWidgets('should be able to toggle all todos complete then all active',
        (tester) async {
      await tester.pumpApp();

      await tester.tap(find.byKey(ArchSampleKeys.statsTab));
      await tester.pumpAndSettle();

      Text text;

      text = tester.firstWidget(find.byKey(ArchSampleKeys.statsNumCompleted));
      expect(text.data, '1');
      text = tester.firstWidget(find.byKey(ArchSampleKeys.statsNumActive));
      expect(text.data, '2');

      //all to completed
      await tester.tap(find.byKey(ArchSampleKeys.extraActionsButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(ArchSampleKeys.toggleAll));
      await tester.pumpAndSettle();

      text = tester.firstWidget(find.byKey(ArchSampleKeys.statsNumCompleted));
      expect(text.data, '3');
      text = tester.firstWidget(find.byKey(ArchSampleKeys.statsNumActive));
      expect(text.data, '0');

      //all to active
      await tester.tap(find.byKey(ArchSampleKeys.extraActionsButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(ArchSampleKeys.toggleAll));
      await tester.pumpAndSettle();

      text = tester.firstWidget(find.byKey(ArchSampleKeys.statsNumCompleted));
      expect(text.data, '0');
      text = tester.firstWidget(find.byKey(ArchSampleKeys.statsNumActive));
      expect(text.data, '3');
    });

    testWidgets('should be able to clear the completed todos', (tester) async {
      await tester.pumpApp();

      await tester.tap(find.byKey(ArchSampleKeys.statsTab));
      await tester.pumpAndSettle();

      Text text;

      text = tester.firstWidget(find.byKey(ArchSampleKeys.statsNumCompleted));
      expect(text.data, '1');
      text = tester.firstWidget(find.byKey(ArchSampleKeys.statsNumActive));
      expect(text.data, '2');

      //all to completed
      await tester.tap(find.byKey(ArchSampleKeys.extraActionsButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(ArchSampleKeys.toggleAll));
      await tester.pumpAndSettle();

      text = tester.firstWidget(find.byKey(ArchSampleKeys.statsNumCompleted));
      expect(text.data, '3');
      text = tester.firstWidget(find.byKey(ArchSampleKeys.statsNumActive));
      expect(text.data, '0');

      //clear all completed
      await tester.tap(find.byKey(ArchSampleKeys.extraActionsButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(ArchSampleKeys.clearCompleted));
      await tester.pumpAndSettle();

      text = tester.firstWidget(find.byKey(ArchSampleKeys.statsNumCompleted));
      expect(text.data, '0');
      text = tester.firstWidget(find.byKey(ArchSampleKeys.statsNumActive));
      expect(text.data, '0');
    });

    testWidgets('should be able to toggle a todo complete', (tester) async {
      await tester.pumpApp();

      await tester.tap(find.byKey(ArchSampleKeys.todoItemCheckbox('1')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(ArchSampleKeys.statsTab));
      await tester.pumpAndSettle();

      Text text;

      text = tester.firstWidget(find.byKey(ArchSampleKeys.statsNumCompleted));
      expect(text.data, '2');
      text = tester.firstWidget(find.byKey(ArchSampleKeys.statsNumActive));
      expect(text.data, '1');
    });

    testWidgets('should be able to add a todo', (tester) async {
      final task = 'Plan day trip to pyramids';
      final note = 'Take picture next to Great Pyramid of Giza!';

      // init to home screen
      await tester.pumpApp();

      // go to add screen and enter a _todo
      await tester.tap(find.byKey(ArchSampleKeys.addTodoFab));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(ArchSampleKeys.taskField), task);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(ArchSampleKeys.noteField), note);
      await tester.pumpAndSettle();

      // save and return to home screen and find new _todo
      await tester.tap(find.byKey(ArchSampleKeys.saveNewTodo));
      await tester.pumpAndSettle();

      expect(find.text(task), findsOneWidget);
    });

    testWidgets('should be able to modify a todo', (tester) async {
      final task = 'T1';
      final taskEdit = 'Plan full day trip to pyramids';
      final noteEdit =
          'Have lunch next to Great Pyramid of Giza and take pictures!';

      // init to home screen
      await tester.pumpApp();

      // find the _todo text to edit and go to details screen
      await tester.tap(find.text(task));
      await tester.pumpAndSettle();

      expect(find.byType(DetailsScreen), findsOneWidget);

      // go to edit screen and edit this _todo
      await tester.tap(find.byKey(ArchSampleKeys.editTodoFab));
      await tester.pumpAndSettle();
      expect(find.byType(EditTodoScreen), findsOneWidget);

      await tester.enterText(find.byKey(ArchSampleKeys.taskField), taskEdit);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(ArchSampleKeys.noteField), noteEdit);
      await tester.pumpAndSettle();

      // save and return to details screen
      await tester.tap(find.byKey(ArchSampleKeys.saveTodoFab));
      await tester.pumpAndSettle();
      expect(find.byType(DetailsScreen), findsOneWidget);

      expect(find.text(taskEdit), findsOneWidget);
      expect(find.text(noteEdit), findsOneWidget);

      // check shows up on home screen
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text(taskEdit), findsOneWidget);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpApp({bool settle = true}) async {
    WidgetsFlutterBinding.ensureInitialized();
    var app = App(
      repository: MockRepository(MockRepository.defaultTodos),
      isTest: true, //set locele to en
    );
    runApp(app);

    if (settle) {
      await pumpAndSettle();
    } else {
      await pump();
    }
  }
}
