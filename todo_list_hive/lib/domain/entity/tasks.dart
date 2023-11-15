import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'tasks.g.dart';

@HiveType(typeId: 1)
class Tasks extends HiveObject {
  @HiveField(0)
  String nameTask;

  @HiveField(1)
  bool isDone;

  Tasks({
    required this.nameTask,
    required this.isDone,
  });
}
