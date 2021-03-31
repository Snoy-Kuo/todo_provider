import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_provider/common/todos_app_core/todos_app_core.dart';
import 'package:todo_provider/models/models.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen() : super(key: ArchSampleKeys.addTodoScreen);

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleEditingController = TextEditingController();
  final _notesEditingController = TextEditingController();

  @override
  void dispose() {
    _titleEditingController.dispose();
    _notesEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Todo'),
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.disabled,
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                key: ArchSampleKeys.taskField,
                controller: _titleEditingController,
                decoration: InputDecoration(
                  hintText: 'What needs to be done?',
                ),
                style: textTheme.headline5,
                autofocus: true,
                validator: (val) {
                  return val!.trim().isEmpty ? 'Please enter some text' : null;
                },
              ),
              TextFormField(
                key: ArchSampleKeys.noteField,
                controller: _notesEditingController,
                style: textTheme.subtitle1,
                decoration: InputDecoration(hintText: 'Additional Notes...'),
                maxLines: 10,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: ArchSampleKeys.saveNewTodo,
        tooltip: 'Add Todo',
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Provider.of<TodoListModel>(context, listen: false).addTodo(Todo(
              _titleEditingController.text,
              note: _notesEditingController.text,
            ));
            Navigator.pop(context);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
