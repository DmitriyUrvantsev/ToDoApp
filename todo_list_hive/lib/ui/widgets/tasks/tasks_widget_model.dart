import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list_hive_refactoring/ui/widgets/group/group_widget_model.dart';
import '../../../domain/data_provider/hive_box_manager.dart';
import '../../../domain/entity/tasks.dart';
import '../../navigation/main_navigation.dart';

class TasksWidgetModel extends ChangeNotifier {
  final TaskWidgetConfiguration configuration;

  late final Future<Box<Tasks>> _tasksBox;
  List<Tasks>? _tasks;
  List<Tasks>? get tasks => _tasks;

  ValueListenable<Object>? _listenablebox;

  TasksWidgetModel({required this.configuration}) {
    _setup();
  }
  void showNewTaskForm(BuildContext context) {
    Navigator.of(context)
        .pushNamed(MainNavigationRoutsName.newTasks, arguments: configuration);
  }

//!--------------------------------Change Task-------------------------------------------------------------

  Future<void> _readTasks() async {
    _tasks = (await _tasksBox).values.toList();
    //! Кладем таски нашей группы в List
    notifyListeners();
  }

  Future<void> _loadTasks() async {
    final box = await _tasksBox; // Ждем пока откроется группБокс
    _readTasks();
    _listenablebox = box.listenable();
    _listenablebox?.addListener(_readTasks);
    notifyListeners();
  }

  void _setup() {
    _tasksBox = BoxManager.instance
        .openTaskBox(configuration.groupKey); //открываем Бокс групп
    _readTasks();
    _loadTasks();
  }

  Future<void> deleteTask(int index) async {
    (await _tasksBox).deleteAt(index);
  }
//!----------------------------------------is Done-------------------------

  void turnIsDone(int index) async {
    final taskList = (await _tasksBox).values.toList();
    final task = taskList[index];
    bool stateIsDone = task.isDone;
    task.isDone = !stateIsDone;
    notifyListeners();
  }
  //!--------------------

  @override
  Future<void> dispose() async {
    _listenablebox?.removeListener(_readTasks);
    BoxManager.instance.closeBox((await _tasksBox));
    super.dispose();
  }
}

class TasksWidgetModelProvider extends InheritedNotifier<TasksWidgetModel> {
  final TasksWidgetModel model;
  const TasksWidgetModelProvider(
      {Key? key, required this.model, required Widget child})
      : super(
          key: key,
          notifier: model,
          child: child,
        );

  static TasksWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TasksWidgetModelProvider>();
    //?.notifier;
  }

  static TasksWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TasksWidgetModelProvider>()
        ?.widget;
    return widget is TasksWidgetModelProvider ? widget : null;
  }
}
