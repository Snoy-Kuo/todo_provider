import 'package:flutter/material.dart' hide Action;
import 'package:provider/provider.dart';
import 'package:todo_provider/common/todos_app_core/todos_app_core.dart';
import 'package:todo_provider/models/models.dart';
import 'package:todo_provider/sceens/home/todo_list_view.dart';

import 'extra_actions_button.dart';
import 'filter_button.dart';
import 'stats_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Because the state of the tabs is only a concern to the HomeScreen Widget,
  // it is stored as local state rather than in the TodoListModel.
  final _tab = ValueNotifier(_HomeScreenTab.todos);

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Provider'),
        actions: <Widget>[
          ValueListenableBuilder<_HomeScreenTab>(
            valueListenable: _tab,
            builder: (_, tab, __) => FilterButton(
              isActive: tab == _HomeScreenTab.todos,
            ),
          ),
          const ExtraActionsButton(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: ArchSampleKeys.addTodoFab,
        onPressed: () => Navigator.pushNamed(context, ArchSampleRoutes.addTodo),
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
      body: Selector<TodoListModel, bool>(
        selector: (context, model) => model.isLoading,
        builder: (context, isLoading, _) {
          if (isLoading) {
            return Center(
              child: CircularProgressIndicator(
                key: ArchSampleKeys.todosLoading,
              ),
            );
          }

          return ValueListenableBuilder<_HomeScreenTab>(
            valueListenable: _tab,
            builder: (context, tab, _) {
              switch (tab) {
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
            },
          );
        },
      ),
      bottomNavigationBar: ValueListenableBuilder<_HomeScreenTab>(
        valueListenable: _tab,
        builder: (context, tab, _) {
          return BottomNavigationBar(
            key: ArchSampleKeys.tabs,
            currentIndex: _HomeScreenTab.values.indexOf(tab),
            onTap: (int index) => _tab.value = _HomeScreenTab.values[index],
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.list, key: ArchSampleKeys.todoTab),
                label: 'Todos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.show_chart, key: ArchSampleKeys.statsTab),
                label: 'Stats',
              ),
            ],
          );
        },
      ),
    );
  }

  void _showUndoSnackbar(BuildContext context, Todo todo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: ArchSampleKeys.snackbar,
        duration: const Duration(seconds: 2),
        content: Text(
          'Deleted "${todo.task}"',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        action: SnackBarAction(
          key: ArchSampleKeys.snackbarAction(todo.id),
          label: 'Undo',
          onPressed: () =>
              Provider.of<TodoListModel>(context, listen: false).addTodo(todo),
        ),
      ),
    );
  }
}

enum _HomeScreenTab { todos, stats }
