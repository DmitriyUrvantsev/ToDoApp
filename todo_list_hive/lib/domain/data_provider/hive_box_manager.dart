import 'package:hive_flutter/hive_flutter.dart';

import '../entity/group.dart';
import '../entity/tasks.dart';

class BoxManager {
  final Map<String, int> _boxCounter =
      {}; //! кастом контроллер коллво открытий и закрытий бокса
  static final BoxManager instance = BoxManager._();
  //патерн синглтон - чтобы экземпляр этого класса был один на все приложение

  BoxManager._(); //!это конструктор класса и сделан приватным, чтобы никто в приложении не мог создать экземпляр этого класса самомтоятельно

  Future<Box<Group>> openGroupBox() async {
    return _openBox('group', 0, GroupAdapter());
  }

  Future<Box<Tasks>> openTaskBox(int groupKey) async {
    return _openBox(makeTaskBoxName(groupKey), 1, TasksAdapter());
    //!теперь у каждой группы будет создаваться свой таск_бокс с Ключем Группы
  }

  String makeTaskBoxName(int groupKey) => 'tasks_$groupKey';

  Future<void> closeBox<T>(Box<T> box) async {
    if (!Hive.isBoxOpen(box.name)) {
      // если не открыт ! - !!!!!!!!!!!!!!!
      _boxCounter.remove(box.name); //удалить int по name
      return;
    }
    if (Hive.isBoxOpen(box.name)) {
      // если открыт
       int count = _boxCounter[box.name] ?? 1; // если null, тогда 1
      count -= 1;
      _boxCounter[box.name] = count;
      if (count > 0) {
        return; //! если >0, значит открыл больше чем закрыл  - и закрывать не надо.
      }
      //! если 0, то значит открыл столько же сколько и закрыл  - нужно закрывать

      _boxCounter.remove(box.name); //удалить int по name
      await box.compact();
      await box.close();
    }
  }

//_____________________________________
  Future<Box<T>> _openBox<T>(
      String name, int typeID, TypeAdapter<T> adapter) async {
    if (Hive.isBoxOpen(name)) {
      final int count = _boxCounter[name] ?? 1; // если null, тогда 1
      _boxCounter[name] = count + 1;
      return Hive.box(name);
    } else {
      if (!Hive.isAdapterRegistered(typeID)) {
        Hive.registerAdapter(adapter);
      }
      _boxCounter[name] = 1;
      return Hive.openBox<T>(name);
    }

    //! await не указываем, потому что возвращаем Future - потом подождут
  }
}
