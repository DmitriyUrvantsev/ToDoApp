import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../group/group_widget_model.dart';
import 'tasks_widget_model.dart';

class TasksWidget extends StatefulWidget {
  final TaskWidgetConfiguration configuration;

  const TasksWidget({
    Key? key,
    required this.configuration,
  }) : super(key: key);

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  late final TasksWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TasksWidgetModel(configuration: widget.configuration);
  }

  @override
  Widget build(BuildContext context) {
    return TasksWidgetModelProvider(
        model: _model,
        child: TasksWidgetBody(configuration: widget.configuration));
  }
}

class TasksWidgetBody extends StatelessWidget {
  final TaskWidgetConfiguration configuration;

  const TasksWidgetBody({
    Key? key,
    required this.configuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final read = TasksWidgetModelProvider.read(context)?.model;
    final watch = TasksWidgetModelProvider.watch(context)?.model;
    final groupName = configuration.groupName;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(child: Text(groupName)),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () => read?.showNewTaskForm(context),
          child: const Icon(Icons.add)),
      body: ListView.separated(
        itemCount: watch?.tasks?.length ?? 0,
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
    final watch = TasksWidgetModelProvider.watch(context)!.model;
    final read = TasksWidgetModelProvider.read(context)!.model;
    final icon = read.tasks![listIndex].isDone ? Icons.done : null;
    TextStyle? textStyle = read.tasks![listIndex].isDone
        ? const TextStyle(decoration: TextDecoration.lineThrough)
        : null;

    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            spacing: 2,
            onPressed: (
              context,
            ) =>
                read.deleteTask(listIndex),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        title: Text('${watch.tasks?[listIndex].nameTask}', style: textStyle),
        trailing: Icon(icon),
        onTap: () => read.turnIsDone(listIndex),
      ),
    );
  }
}
