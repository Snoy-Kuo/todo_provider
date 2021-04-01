import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_provider/common/todos_app_core/todos_app_core.dart';
import 'package:todo_provider/l10n/l10n.dart';
import 'package:todo_provider/models/models.dart';

class StatsView extends StatelessWidget {
  const StatsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              l10n(context).completedTodos,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Selector<TodoListModel, int>(
              selector: (_, model) => model.numCompleted,
              builder: (context, numCompleted, _) => Text(
                '$numCompleted',
                key: ArchSampleKeys.statsNumCompleted,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              l10n(context).activeTodos,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Selector<TodoListModel, int>(
              selector: (_, model) => model.numActive,
              builder: (context, numActive, _) => Text(
                '$numActive',
                key: ArchSampleKeys.statsNumActive,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          )
        ],
      ),
    );
  }
}
