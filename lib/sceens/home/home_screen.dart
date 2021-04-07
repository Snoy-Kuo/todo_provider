import 'package:flutter/material.dart' hide Action;
import 'package:provider/provider.dart';
import 'package:todo_provider/common/logger.dart';
import 'package:todo_provider/common/todos_app_core/todos_app_core.dart';
import 'package:todo_provider/l10n/l10n.dart';
import 'package:todo_provider/models/models.dart';
import 'package:todo_provider/sceens/home/todo_list_view.dart';

import 'extra_actions_button.dart';
import 'filter_button.dart';
import 'stats_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _HomeScreenTabModel(),
      child: _homeScreen(context),
    );
  }
}

Widget _homeScreen(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(l10n(context).appTitle),
      actions: <Widget>[
        Consumer<_HomeScreenTabModel>(
            builder: (context, model, child) => FilterButton(
                  isActive: model.tab == _HomeScreenTab.todos,
                )),
        const ExtraActionsButton(),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      key: ArchSampleKeys.addTodoFab,
      onPressed: () => Navigator.pushNamed(context, ArchSampleRoutes.addTodo),
      tooltip: l10n(context).addTodo,
      child: const Icon(Icons.add),
    ),
    body: Selector<TodoListModel, bool>(
      selector: (context, model) => model.isLoading,
      builder: (context, isLoading, _) {
        logger.d('isLoading=$isLoading');
        if (isLoading) {
          return Center(
            child: CircularProgressIndicator(
              key: ArchSampleKeys.todosLoading,
            ),
          );
        }

        return Consumer<_HomeScreenTabModel>(builder: (context, model, child) {
          switch (model.tab) {
            case _HomeScreenTab.stats:
              return const StatsView();
            case _HomeScreenTab.todos:
            default:
              return TodoListView(
                onRemove: (context, todo) {
                  Provider.of<TodoListModel>(context, listen: false)
                      .removeTodo(todo);
                  _showUndoSnackbar(context, todo);
                },
              );
          }
        });
      },
    ),
    bottomNavigationBar:
        Consumer<_HomeScreenTabModel>(builder: (context, model, child) {
      return BottomNavigationBar(
        key: ArchSampleKeys.tabs,
        currentIndex: _HomeScreenTab.values.indexOf(model.tab),
        onTap: (int index) => model.tab = _HomeScreenTab.values[index],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list, key: ArchSampleKeys.todoTab),
            label: l10n(context).todos,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart, key: ArchSampleKeys.statsTab),
            label: l10n(context).stats,
          ),
        ],
      );
    }),
  );
}

void _showUndoSnackbar(BuildContext context, Todo todo) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      key: ArchSampleKeys.snackbar,
      duration: const Duration(seconds: 2),
      content: Text(
        l10n(context).deletedTodoTask(todo.task),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      action: SnackBarAction(
        key: ArchSampleKeys.snackbarAction(todo.id),
        label: l10n(context).undo,
        onPressed: () =>
            Provider.of<TodoListModel>(context, listen: false).addTodo(todo),
      ),
    ),
  );
}

enum _HomeScreenTab { todos, stats }

class _HomeScreenTabModel extends ChangeNotifier {
  _HomeScreenTab _tab = _HomeScreenTab.todos;

  _HomeScreenTab get tab => _tab;

  set tab(_HomeScreenTab newTab) {
    _tab = newTab;

    notifyListeners();
  }
}
