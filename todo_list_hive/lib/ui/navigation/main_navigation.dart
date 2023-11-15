import 'package:flutter/material.dart';

import '../widgets/group/group_widget.dart';
import '../widgets/group/group_widget_model.dart';
import '../widgets/group/group_form/group_form_widget.dart';
import '../widgets/tasks/task_form/tasks_form_widget.dart';
import '../widgets/tasks/tasks_widget.dart';

abstract class MainNavigationRoutsName {
  static const group = '/';
  static const groupNewGroup = '/newgroup';
  static const tasks = '/tasks';
  static const newTasks = '/tasks/newtasks';
}

class MainNavigation {
  final initialRoute = MainNavigationRoutsName.group;
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRoutsName.group: (context) => const GroupWidget(),
    MainNavigationRoutsName.groupNewGroup: (context) => const GroupFormWidget(),
    //! groupKey здесь мы не можем передать? поэтому см.: onGenerateRoutes наша функция ниже
  };

//----------------наша функция где можно передать arg ---------------------------------
  Route<Object> onGenerateRoutes(RouteSettings settings) {
    //!Если маршрут(routes) показываться не будет, то вызовется эта функция и мы передадим arg
//! здесь мы можем передать RouteSettings - то есть нужный нам groupKey
    switch (settings.name) {
      //будем проверять, что это за name

      case MainNavigationRoutsName.tasks: // будем возвращать маршруты
        final TaskWidgetConfiguration configuration =
            settings.arguments as TaskWidgetConfiguration;
        return MaterialPageRoute(
            builder: (context) => TasksWidget(
                  configuration: configuration,
                ));

      case MainNavigationRoutsName.newTasks:
        final TaskWidgetConfiguration configuration =
            settings.arguments as TaskWidgetConfiguration;

        return MaterialPageRoute(
            builder: (context) => TasksFormWidget(
                  configuration: configuration,
                ));

      default:
        const widget = Text('Navigation Error');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}
