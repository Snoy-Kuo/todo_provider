import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todo_provider/common/todos_app_core/todos_app_core.dart';
import 'package:todo_provider/common/todos_repository_core/todos_repository_core.dart';
import 'package:todo_provider/l10n/l10n.dart';
import 'package:todo_provider/models/models.dart';
import 'package:todo_provider/sceens/home/home_screen.dart';

import 'mock_repository.dart';

/// Demonstrates how to test Widgets in combination with a ChangeNotifier
void main() {
  group('HomeScreen', () {
    final todoListFinder = find.byKey(ArchSampleKeys.todoList);
    final todoItem1Finder = find.byKey(ArchSampleKeys.todoItem('1'));
    final todoItem2Finder = find.byKey(ArchSampleKeys.todoItem('2'));
    final todoItem3Finder = find.byKey(ArchSampleKeys.todoItem('3'));

    testWidgets('should render loading indicator at first', (tester) async {
      await tester.pumpWidget(_TestWidget(
          repository: MockRepository([], const Duration(seconds: 3))));
      await tester.pump(Duration.zero);

      expect(find.byKey(ArchSampleKeys.todosLoading), findsOneWidget);

      await tester
          .pumpAndSettle(); //skip the remaining delay time before disposing widget. otherwise, the dalay will cause 'A Timer is still pending even after the widget tree was disposed' exception.
    });

    testWidgets('should display a list after loading todos', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_TestWidget());
      await tester.pumpAndSettle();

      final checkbox1 = find.descendant(
        of: find.byKey(ArchSampleKeys.todoItemCheckbox('1')),
        matching: find.byType(Focus),
      );
      final checkbox2 = find.descendant(
        of: find.byKey(ArchSampleKeys.todoItemCheckbox('2')),
        matching: find.byType(Focus),
      );
      final checkbox3 = find.descendant(
        of: find.byKey(ArchSampleKeys.todoItemCheckbox('3')),
        matching: find.byType(Focus),
      );

      expect(todoListFinder, findsOneWidget);
      expect(todoItem1Finder, findsOneWidget);
      expect(find.text('T1'), findsOneWidget);
      expect(find.text('N1'), findsOneWidget);
      expect(tester.getSemantics(checkbox1), isChecked(false));
      expect(todoItem2Finder, findsOneWidget);
      expect(find.text('T2'), findsOneWidget);
      expect(tester.getSemantics(checkbox2), isChecked(false));
      expect(todoItem3Finder, findsOneWidget);
      expect(find.text('T3'), findsOneWidget);
      expect(tester.getSemantics(checkbox3), isChecked(true));

      handle.dispose();
    });

    testWidgets('should remove todos using a dismissible', (tester) async {
      await tester.pumpWidget(_TestWidget());
      await tester.pumpAndSettle();
      await tester.drag(todoItem1Finder, Offset(-1000, 0));
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(todoItem1Finder, findsNothing);
      expect(todoItem2Finder, findsOneWidget);
      expect(todoItem3Finder, findsOneWidget);
    });

    testWidgets('should display stats when switching tabs', (tester) async {
      await tester.pumpWidget(_TestWidget());
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ArchSampleKeys.statsTab));
      await tester.pump();

      expect(find.byKey(ArchSampleKeys.statsNumActive), findsOneWidget);
      expect(find.byKey(ArchSampleKeys.statsNumActive), findsOneWidget);
    });
  });
}

class _TestWidget extends StatelessWidget {
  final Widget? child;
  final TodosRepository? repository;
  final List<Todo>? todos;

  const _TestWidget({
    Key? key,
    this.child,
    this.repository,
    this.todos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoListModel>(
      create: (_) {
        return TodoListModel(
            repository: repository ?? MockRepository(todos ?? _defaultTodos))
          ..loadTodos();
      },
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: child ?? const HomeScreen(),
      ),
    );
  }

  static List<Todo> get _defaultTodos {
    return [
      Todo('T1', id: '1', note: 'N1'),
      Todo('T2', id: '2'),
      Todo('T3', id: '3', complete: true),
    ];
  }
}

Matcher isChecked(bool isChecked) {
  return matchesSemantics(
    isChecked: isChecked,
    hasCheckedState: true,
    hasEnabledState: true,
    isEnabled: true,
    isFocusable: true,
    hasTapAction: true,
  );
}
