import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_provider/common/todos_app_core/todos_app_core.dart';
import 'package:todo_provider/l10n/l10n.dart';
import 'package:todo_provider/models/models.dart';
import 'package:todo_provider/sceens/details/details_screen.dart';

class TodoListView extends StatelessWidget {
  final void Function(BuildContext context, Todo todo) onRemove;

  TodoListView({Key? key, required this.onRemove}) : super(key: key);

  Widget _slideBackground(BuildContext context, {required bool toRight}) {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment:
              toRight ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              width: toRight ? 20 : 0,
            ),
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              l10n(context).delete,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: toRight ? TextAlign.left : TextAlign.right,
            ),
            SizedBox(
              width: toRight ? 0 : 20,
            ),
          ],
        ),
        alignment: toRight ? Alignment.centerLeft : Alignment.centerRight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Selector<TodoListModel, List<Todo>>(
      selector: (_, model) => model.filteredTodos,
      builder: (context, todos, _) {
        return ListView.builder(
          key: ArchSampleKeys.todoList,
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];

            return Dismissible(
              key: ArchSampleKeys.todoItem(todo.id),
              onDismissed: (_) => onRemove(context, todo),
              background: _slideBackground(context, toRight: true),
              secondaryBackground: _slideBackground(context, toRight: false),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return DetailsScreen(
                          id: todo.id,
                          onRemove: () {
                            Navigator.pop(context);
                            onRemove(context, todo);
                          },
                        );
                      },
                    ),
                  );
                },
                leading: Checkbox(
                  key: ArchSampleKeys.todoItemCheckbox(todo.id),
                  value: todo.complete,
                  onChanged: (complete) {
                    Provider.of<TodoListModel>(context, listen: false)
                        .updateTodo(todo.copy(complete: complete));
                  },
                ),
                title: Text(
                  todo.task,
                  key: ArchSampleKeys.todoItemTask(todo.id),
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text(
                  todo.note,
                  key: ArchSampleKeys.todoItemNote(todo.id),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
