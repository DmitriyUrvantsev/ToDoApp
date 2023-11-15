// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import '../../../../domain/data_provider/hive_box_manager.dart';
import '../../../../domain/entity/tasks.dart';
import '../../group/group_widget_model.dart';

class TasksFormWidgetModel extends ChangeNotifier {
  String _taskText = '';
  final TaskWidgetConfiguration configuration;

//--------------------------------------
  bool get isPosible => _taskText.trim().isNotEmpty;

  set taskText(String value) {
    final bool isTaskTextEmty = _taskText
        .trim()
        .isEmpty; //запоминаем показания старого _taskText(предыдущей буквы)
    _taskText = value; //передаем value дальше в _groupName и потом в бокс

    if (value.trim().isEmpty != isTaskTextEmty) {
      // сравниваем новую с предыдущей буквой - если чтото не пустое - то условие выполнено
      notifyListeners(); //уведомляем
    }
  }

//--------------------------------------
  TasksFormWidgetModel({
    required this.configuration,
  });

  void saveTask(context) async {
    final taskText = _taskText.trim();
    if (taskText.isEmpty) {
      return;
    }

    final tasksBox = await BoxManager.instance
        .openTaskBox(configuration.groupKey); //!открываем Бокс tasks
    final task = Tasks(
        nameTask: taskText,
        isDone: false); //Кладем taskText в task(создаем задачу)
    await tasksBox.add(task); //кладем task в tasksBox

    await BoxManager.instance.closeBox(tasksBox);

    Navigator.pop(context);
  }
}

class TasksFormWidgetModelProvider
    extends InheritedNotifier<TasksFormWidgetModel> {
  final TasksFormWidgetModel model;
  const TasksFormWidgetModelProvider(
      {Key? key, required this.model, required Widget child})
      : super(
          key: key,
          notifier: model,
          child: child,
        );

  static TasksFormWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TasksFormWidgetModelProvider>();
    //?.notifier;
  }

  static TasksFormWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TasksFormWidgetModelProvider>()
        ?.widget;
    return widget is TasksFormWidgetModelProvider ? widget : null;
  }
}
