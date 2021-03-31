import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_provider/common/repository_local_storage/repository_local_storage.dart';
import 'package:todo_provider/common/todos_repository_local_storage/todos_repository_local_storage.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(App(
    repository: LocalStorageRepository(
      localStorage: KeyValueStorage(
        'todo_provider',
        await SharedPreferences.getInstance(),
      ),
    ),
  ));
}
