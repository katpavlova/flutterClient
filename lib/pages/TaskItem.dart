import 'package:flutter/material.dart';

import 'Statefull/TaskItemStateFull.dart';

class TaskItem extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: Text(
          "Данные задачи"
        ),
      ),
      body: TaskItemStateFull(args["id"]),
    );
  }

}