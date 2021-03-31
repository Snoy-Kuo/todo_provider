// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_provider/common/todos_app_core/todos_app_core.dart';
import 'package:todo_provider/common/todos_repository_core/todos_repository_core.dart';
import 'package:todo_provider/models/models.dart';
import 'package:todo_provider/sceens/add_todo/add_todo_screen.dart';
import 'package:todo_provider/sceens/home/home_screen.dart';

class App extends StatelessWidget {
  final TodosRepository repository;

  App({
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodoListModel(repository: repository)..loadTodos(),
      child: MaterialApp(
        theme: ArchSampleTheme.theme,
        title: 'Todo Provider',
        routes: {
          ArchSampleRoutes.home: (context) => HomeScreen(),
          ArchSampleRoutes.addTodo: (context) => AddTodoScreen(),
        },
      ),
    );
  }
}
