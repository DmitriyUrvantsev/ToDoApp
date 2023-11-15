// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list_hive_refactoring/domain/data_provider/hive_box_manager.dart';
import '../../../domain/entity/group.dart';
import '../../navigation/main_navigation.dart';

class TaskWidgetConfiguration {
  int groupKey;
  String groupName;
  TaskWidgetConfiguration({
    required this.groupKey,
    required this.groupName,
  });
}

class GroupWidgetModel extends ChangeNotifier {
  late final Future<Box<Group>>
      _groupBox; // Будут вызываться разные методы и все они будут завязаны на _groupBox
  //Не хотелось бы чтобы обращение к боксу было до его первоначальной инициализации
  //Везде где нужно будет поработать с boxом нужно будет ждать выполнения одной и той же Фичи

  List<Group> _groups = <Group>[];
  List<Group> get group => _groups.toList();

  ValueListenable<Object>? _listenablebox;

  GroupWidgetModel() {
    _setup();
  }
//--------------------------------------------------
  void showNewForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRoutsName.groupNewGroup);
  }

  Future<void> showTasks(BuildContext context, groupIndex) async {
    final groupKey = (await _groupBox).keyAt(groupIndex)
        as int; //! это ключ НАШЕЙ группы в боксе
    final groupName = group[groupIndex].nameGroup;

    final configuration =
        TaskWidgetConfiguration(groupKey: groupKey, groupName: groupName);

    unawaited(

        // ignore: use_build_context_synchronously
        Navigator.of(context).pushNamed(MainNavigationRoutsName.tasks,
            arguments: configuration));
  }

//-----------------------------------------------------
  Future<void> _readGroup() async {
    _groups = (await _groupBox).values.toList();
    notifyListeners();
  }

//--------------------------------------------------------

  Future<void> _loadGroups() async {
    _listenablebox = (await _groupBox).listenable(); //это прослушиваемый бокс
    _listenablebox?.addListener(_readGroup); //начинаем наблюдать
  }

  void _setup() async {
    _groupBox = BoxManager.instance.openGroupBox();
    _readGroup();

    _loadGroups();
  }

//-------------------------------------------------------------
  Future<void> deleteGroup(int groupIndex) async {
    final groupKey = (await _groupBox).keyAt(groupIndex) as int;
    //! это ключ НАШЕЙ группы в боксе
    final taskBoxName = BoxManager.instance.makeTaskBoxName(groupKey);
    await Hive.deleteBoxFromDisk(taskBoxName);

    (await _groupBox).deleteAt(groupIndex);
    ////!!!!!!!!!!!!!!!!!!!! AT AT AT AT!!!!!!!!!
  }

  @override
  Future<void> dispose() async {
    _listenablebox?.removeListener(_readGroup); //снимаем наблюдение
    await BoxManager.instance.closeBox((await _groupBox)); //закрываем бокс
    super.dispose();
  }
}

//----------------------------------------

class GroupWidgetModelProvider extends InheritedNotifier<GroupWidgetModel> {
  final GroupWidgetModel model;
  const GroupWidgetModelProvider(
      {Key? key, required this.model, required Widget child})
      : super(
          key: key,
          notifier: model,
          child: child,
        );

  static GroupWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupWidgetModelProvider>();
    //?.notifier;
  }

  static GroupWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupWidgetModelProvider>()
        ?.widget;
    return widget is GroupWidgetModelProvider ? widget : null;
  }
}
