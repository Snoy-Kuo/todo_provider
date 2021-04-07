// Provides a Mock repository that can be used for testing in place of the real
// thing.
import 'package:todo_provider/common/todos_repository_core/todo_entity.dart';
import 'package:todo_provider/common/todos_repository_core/todos_repository.dart';
import 'package:todo_provider/models/todo_model.dart';

class MockRepository extends TodosRepository {
  List<TodoEntity> entities;
  final Duration delay;
  int saveCount = 0;

  MockRepository([List<Todo> todos = const [], this.delay = Duration.zero])
      : entities = todos.map((it) => it.toEntity()).toList();

  @override
  Future<List<TodoEntity>> loadTodos() async {
    return Future.delayed(delay, () => entities);
  }

  @override
  Future saveTodos(List<TodoEntity> todos) async {
    saveCount++;
    entities = todos;
  }
}
