import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_provider/common/todos_app_core/todos_app_core.dart';
import 'package:todo_provider/models/models.dart';

import '../edit/edit_todo_screen.dart';

class DetailsScreen extends StatelessWidget {
  final String id;
  final VoidCallback onRemove;

  const DetailsScreen({required this.id, required this.onRemove})
      : super(key: ArchSampleKeys.todoDetailsScreen);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Details'),
        actions: <Widget>[
          IconButton(
            key: ArchSampleKeys.deleteTodoButton,
            tooltip: 'Delete Todo',
            icon: const Icon(Icons.delete),
            onPressed: onRemove,
          )
        ],
      ),
      body: Selector<TodoListModel, Todo?>(
        selector: (context, model) => model.todoById(id),
        shouldRebuild: (prev, next) => next != null,
        builder: (context, todo, _) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Checkbox(
                        key: ArchSampleKeys.detailsTodoItemCheckbox,
                        value: todo!.complete,
                        onChanged: (complete) {
                          Provider.of<TodoListModel>(context, listen: false)
                              .updateTodo(todo.copy(complete: !todo.complete));
                        },
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              bottom: 16.0,
                            ),
                            child: Text(
                              todo.task,
                              key: ArchSampleKeys.detailsTodoItemTask,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                          Text(
                            todo.note,
                            key: ArchSampleKeys.detailsTodoItemNote,
                            style: Theme.of(context).textTheme.subtitle1,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: ArchSampleKeys.editTodoFab,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditTodoScreen(
                id: id,
                onEdit: (task, note) {
                  final model =
                      Provider.of<TodoListModel>(context, listen: false);
                  final todo = model.todoById(id);

                  model.updateTodo(todo!.copy(task: task, note: note));

                  return Navigator.pop(context);
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
