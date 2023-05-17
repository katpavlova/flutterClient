import 'package:flutter/material.dart';

import 'Statefull/TaskAddStateFull.dart';

class TaskAdd extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Text(
            "Добавление задачи"
        ),
      ),
      body: TaskAddStateFull(context),
    );
  }

}