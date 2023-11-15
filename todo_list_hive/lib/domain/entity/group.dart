// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

 
part 'group.g.dart';

@HiveType(typeId: 0)
class Group extends HiveObject {
  //!last used HiveField(1)
  @HiveField(0)
  String nameGroup;



  Group({
    required this.nameGroup,
  });

 
}
