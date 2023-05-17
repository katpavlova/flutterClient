
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'Statefull/Task.dart';

class Tasks extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<Auth>(context).user;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text(
            "Задачи"
        ),
      ),
      body: Task(context),
      floatingActionButton: user.userRole.contains("MODER") ? FloatingActionButton(
        onPressed: () async{
          final result = await Navigator.pushNamed(context, "/taskAdd");
          print("result - $result");
          if(result != null){
            Navigator.pop(context);
            Navigator.pushNamed(context, "/tasks");
          }
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ) : null,
    );
  }

}