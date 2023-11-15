import 'package:flutter/material.dart';

import '../../group/group_widget_model.dart';
import 'tasks_form_widget_model.dart';

class TasksFormWidget extends StatefulWidget {
  final TaskWidgetConfiguration configuration;

  // final int groupKey;
  const TasksFormWidget({super.key, required this.configuration});

  @override
  State<TasksFormWidget> createState() => _TasksFormWidgetState();
}

class _TasksFormWidgetState extends State<TasksFormWidget> {
  late final TasksFormWidgetModel
      _model; //! модель! которая 100% будет и  обьявим позже так как groupKey будет позже

  @override
  void initState() {
    super.initState();
    final configuration = widget.configuration;
    _model = TasksFormWidgetModel(configuration: configuration);
  }

  @override
  Widget build(BuildContext context) {
    return TasksFormWidgetModelProvider(
        model: _model, child: const _TasksFormWidgetBody());
  }
}

class _TasksFormWidgetBody extends StatelessWidget {
  const _TasksFormWidgetBody();

  @override
  Widget build(BuildContext context) {
    final model = TasksFormWidgetModelProvider.watch(context)?.model;
    var actionButton = FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => model?.saveTask(context),
        child: const Icon(Icons.done));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Новая задача'),
      ),
      floatingActionButton: model?.isProsible == true ? actionButton : null,
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _TasksNameWidget(),
        ),
      ),
    );
  }
}

class _TasksNameWidget extends StatelessWidget {
  const _TasksNameWidget();

  @override
  Widget build(BuildContext context) {
    final model = TasksFormWidgetModelProvider.watch(context)?.model;

    return TextField(
      autofocus: true,
      minLines: null,
      maxLines: null,
      expands: true,
      decoration: const InputDecoration(
        border: InputBorder.none,
        labelText: 'New Task',
      ),
      onChanged: (value) => model!.taskText = value,
      onEditingComplete: () => model!.saveTask(context),
    );
  }
}
