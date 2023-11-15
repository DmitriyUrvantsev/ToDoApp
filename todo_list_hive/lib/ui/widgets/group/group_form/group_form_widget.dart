import 'package:flutter/material.dart';

import 'group_form_widget_model.dart';

class GroupFormWidget extends StatefulWidget {
  const GroupFormWidget({super.key});

  @override
  State<GroupFormWidget> createState() => _GroupFormWidgetState();
}

class _GroupFormWidgetState extends State<GroupFormWidget> {
  final _model = GroupFormWidgetModel();
  @override
  Widget build(BuildContext context) {
    return GroupFormWidgetModelProvider(
        model: _model, child: const _GroupFormWidgetBody());
  }
}

class _GroupFormWidgetBody extends StatelessWidget {
  const _GroupFormWidgetBody();

  @override
  Widget build(BuildContext context) {
    final model = GroupFormWidgetModelProvider.read(context)?.model;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новая Группа'),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () => model?.saveGroup(context),
          child: const Icon(Icons.done)),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _GroupNameWidget(),
        ),
      ),
    );
  }
}

class _GroupNameWidget extends StatelessWidget {
  const _GroupNameWidget();

  @override
  Widget build(BuildContext context) {
    final read = GroupFormWidgetModelProvider.read(context)?.model;
    final watch = GroupFormWidgetModelProvider.watch(context)?.model;

    return TextField(
        autofocus: true,
        decoration:  InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Password',
          errorText: watch?.errorText,
        ),
        onChanged: (value) => {
              read?.groupName = value,
            },
        onEditingComplete: () => {
              read?.saveGroup(context),
            });
  }
}
