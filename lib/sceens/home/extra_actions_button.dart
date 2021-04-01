// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_provider/common/todos_app_core/todos_app_core.dart';
import 'package:todo_provider/l10n/l10n.dart';
import 'package:todo_provider/models/models.dart';

class ExtraActionsButton extends StatelessWidget {
  const ExtraActionsButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TodoListModel>(context);

    return PopupMenuButton<ExtraAction>(
      key: ArchSampleKeys.extraActionsButton,
      onSelected: (action) {
        switch (action) {
          case ExtraAction.toggleAllComplete:
            model.toggleAll();
            break;
          case ExtraAction.clearCompleted:
            model.clearCompleted();
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuItem<ExtraAction>>[
          PopupMenuItem<ExtraAction>(
            key: ArchSampleKeys.toggleAll,
            value: ExtraAction.toggleAllComplete,
            child: Text(model.hasActiveTodos
                ? l10n(context).markAllComplete
                : l10n(context).markAllIncomplete),
          ),
          PopupMenuItem<ExtraAction>(
            key: ArchSampleKeys.clearCompleted,
            value: ExtraAction.clearCompleted,
            child: Text(l10n(context).clearCompleted),
          ),
        ];
      },
    );
  }
}

enum ExtraAction { toggleAllComplete, clearCompleted }
