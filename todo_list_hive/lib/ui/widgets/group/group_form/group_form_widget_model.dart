import 'package:flutter/material.dart';
import '../../../../domain/data_provider/hive_box_manager.dart';
import '../../../../domain/entity/group.dart';

class GroupFormWidgetModel extends ChangeNotifier {
  String _groupName = '';
  String? errorText;

  set groupName(String value) {
    //сюда приходит value из TextField
    //! Сеттер чтобы убирать errorText когда снова начинаем вводить текст после ошибки
    if (errorText != null && _groupName.trim().isNotEmpty) {
      //если уже есть ошибка и начали набирать текст
      errorText = null;
      //убираем ошибку
      notifyListeners(); //уведомляем
    }
    _groupName = value; //передаем value дальше в _groupName и потом в бокс
  }

  void saveGroup(context) async {
    final groupName = _groupName.trim();
    if (groupName.isEmpty) {
      errorText = 'Введите имя группы';
      notifyListeners();
      return;
    }
    final box = await BoxManager.instance.openGroupBox();
    final group = Group(nameGroup: groupName);
    await box.add(group);
    await BoxManager.instance.closeBox(box);
    Navigator.pop(context);
  }
}

//--------------------------------------------

class GroupFormWidgetModelProvider
    extends InheritedNotifier<GroupFormWidgetModel> {
  final GroupFormWidgetModel model;
  const GroupFormWidgetModelProvider(
      {Key? key, required this.model, required Widget child})
      : super(
          key: key,
          notifier: model,
          child: child,
        );

  static GroupFormWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupFormWidgetModelProvider>();
    //?.notifier;
  }

  static GroupFormWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupFormWidgetModelProvider>()
        ?.widget;
    return widget is GroupFormWidgetModelProvider
        ? widget
        : null; //                   .notifier : null;
  }

  // @override
  //bool updateShouldNotify(GroupFormWidgetModelProvider oldWidget) {
  //  return notifier != oldWidget.notifier;
}
