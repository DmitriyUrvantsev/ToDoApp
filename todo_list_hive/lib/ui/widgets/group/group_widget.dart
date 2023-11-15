import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'group_widget_model.dart';

//import 'package:hive/hive.dart';
//import 'package:hive_flutter/hive_flutter.dart';

//import 'group_widget_model.dart';

class GroupWidget extends StatefulWidget {
  const GroupWidget({super.key});

  @override
  State<GroupWidget> createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  final _model = GroupWidgetModel();
  @override
  Widget build(BuildContext context) {
    return GroupWidgetModelProvider(
        model: _model, child: const GroupWidgetBody());
  }

  //! @override  - лучше делать через контроль закрытия счетчиком
  //! void dispose() async {
  //!   await _model.dispose();
  //!   super.dispose();
  //! }
}

class GroupWidgetBody extends StatelessWidget {
  const GroupWidgetBody({super.key});

  @override
  Widget build(BuildContext context) {
    final read = GroupWidgetModelProvider.read(context)?.model;
    final watch = GroupWidgetModelProvider.watch(context)?.model;

    // final groupList = GroupWidgetModelProvider.watch(context)?.groupList;
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Группы')),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () => read?.showNewForm(context),
          child: const Icon(Icons.add)),
      body: ListView.separated(
        itemCount: watch?.group.length ?? 1, //groupList?.length ?? 1,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          return GroupItemWidget(listIndex: index);
        },
      ),
    );
  }
}

class GroupItemWidget extends StatelessWidget {
  const GroupItemWidget({
    super.key,
    required this.listIndex,
  });
  final int listIndex;

  @override
  Widget build(BuildContext context) {
    //final watch = GroupWidgetModelProvider.watch(context)?.model;
    final read = GroupWidgetModelProvider.read(context)?.model;

    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            spacing: 2,
            onPressed: (context) =>
                read?.deleteGroup(listIndex), //!!!!!!!!!!!!!!
            //onPressed: () => {},//(listIndex) => read?.deleteGroup(listIndex as int),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        title: Text('${read?.group[listIndex].nameGroup}:'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => read?.showTasks(context, listIndex),
      ),
    );
  }
}
