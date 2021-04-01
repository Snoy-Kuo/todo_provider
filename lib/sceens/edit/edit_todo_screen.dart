import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_provider/common/todos_app_core/todos_app_core.dart';
import 'package:todo_provider/l10n/l10n.dart';
import 'package:todo_provider/models/models.dart';

class EditTodoScreen extends StatefulWidget {
  final void Function(String task, String note) onEdit;
  final String id;

  const EditTodoScreen({
    required this.id,
    required this.onEdit,
  }) : super(key: ArchSampleKeys.editTodoScreen);

  @override
  _EditTodoScreenState createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _taskController;
  late TextEditingController _noteController;

  @override
  void initState() {
    final todo =
        Provider.of<TodoListModel>(context, listen: false).todoById(widget.id);
    _taskController = TextEditingController(text: todo?.task);
    _noteController = TextEditingController(text: todo?.note);
    super.initState();
  }

  @override
  void dispose() {
    _taskController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n(context).editTodo)),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _taskController,
                key: ArchSampleKeys.taskField,
                style: Theme.of(context).textTheme.headline5,
                decoration: InputDecoration(
                  hintText: l10n(context).inputTodoHint,
                ),
                validator: (val) {
                  return val!.trim().isEmpty
                      ? l10n(context).inputTodoEmptyWarning
                      : null;
                },
              ),
              TextFormField(
                controller: _noteController,
                key: ArchSampleKeys.noteField,
                decoration: InputDecoration(
                  hintText: l10n(context).additionalNotes,
                ),
                maxLines: 10,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: ArchSampleKeys.saveTodoFab,
        tooltip: l10n(context).saveChanges,
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            widget.onEdit(_taskController.text, _noteController.text);
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
