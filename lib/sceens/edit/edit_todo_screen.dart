import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_provider/common/todos_app_core/todos_app_core.dart';
import 'package:todo_provider/l10n/l10n.dart';
import 'package:todo_provider/models/models.dart';

class EditTodoScreen extends StatelessWidget {
  final void Function(String task, String note) onEdit;
  final String id;

  const EditTodoScreen({
    required this.id,
    required this.onEdit,
  }) : super(key: ArchSampleKeys.editTodoScreen);

  @override
  Widget build(BuildContext context) {
    final todo =
        Provider.of<TodoListModel>(context, listen: false).todoById(id);
    return ChangeNotifierProvider(
      create: (_) => _EditTodoScreenModel(task: todo!.task, note: todo.note),
      child: _editTodoScreen(context, id: id, onEditFun: this.onEdit),
    );
  }

  Widget _editTodoScreen(BuildContext context,
      {required String id,
      required void Function(String task, String note) onEditFun}) {
    String? todoTaskErrorText;

    return Scaffold(
      appBar: AppBar(title: Text(l10n(context).editTodo)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<_EditTodoScreenModel>(
          builder: (context, model, child) => Column(
            children: <Widget>[
              TextFormField(
                key: ArchSampleKeys.taskField,
                style: Theme.of(context).textTheme.headline5,
                initialValue: model.task,
                onChanged: (val) {
                  model.todoTask = val;
                  todoTaskErrorText = val.trim().isEmpty
                      ? l10n(context).inputTodoEmptyWarning
                      : null;
                },
                decoration: InputDecoration(
                    hintText: l10n(context).inputTodoHint,
                    errorText: todoTaskErrorText),
              ),
              TextFormField(
                key: ArchSampleKeys.noteField,
                initialValue: model.note,
                onChanged: (val) => {model.todoNote = val},
                decoration: InputDecoration(
                  hintText: l10n(context).additionalNotes,
                ),
                maxLines: 10,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Consumer<_EditTodoScreenModel>(
        builder: (context, model, child) => FloatingActionButton(
          key: ArchSampleKeys.saveTodoFab,
          tooltip: l10n(context).saveChanges,
          onPressed: () {
            if (todoTaskErrorText == null) {
              onEditFun(model.task, model.note);
            }
          },
          child: const Icon(Icons.check),
        ),
      ),
    );
  }
}

class _EditTodoScreenModel extends ChangeNotifier {
  String task;
  String note;

  _EditTodoScreenModel({required this.task, required this.note});

  set todoTask(String newTodoTask) {
    task = newTodoTask;
    notifyListeners();
  }

  set todoNote(String newTodoNote) {
    note = newTodoNote;
    notifyListeners();
  }
}
