import 'package:flutter/material.dart';

import '../../jsonSerializables/tasks.dart';
import '../../jsonSerializables/accountables.dart';

// ignore: must_be_immutable
class Task extends StatefulWidget{
  BuildContext context;
  Task(this.context, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _TaskState();
  }

}

class _TaskState extends State<Task>{
  late Future<AccountablesList> accountablesList;
  late Future<TasksList> tasksList;

  @override
  void initState(){
    super.initState();
    accountablesList = getAccountablesList(widget.context);
    tasksList = getTasksList(widget.context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AccountablesList>(
      future: accountablesList,
      builder: (context, snapshotAccountable){
        if(snapshotAccountable.hasData){
          return FutureBuilder<TasksList>(
            future: tasksList,
            builder: (context, snapshotTask){
              if(snapshotTask.hasData){
                return ListView.builder(
                  itemCount: snapshotTask.data?.tasks.length,
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap: () async{
                        final result = await Navigator.pushNamed(context, "/taskItem", arguments: {
                          "id": "${snapshotTask.data?.tasks[index].id}"
                        });
                        print("result - $result");
                        if(result != null){
                          Navigator.pop(context);
                          Navigator.pushNamed(context, "/tasks");
                        }

                      },
                      child: Card(
                        child: ListTile(
                          title: Text("${snapshotTask.data?.tasks[index].name}"),
                          subtitle: Text(
                              "${
                                  snapshotAccountable.data?.accountables.firstWhere(
                                          (element) => element.id == snapshotTask.data?.tasks[index].accontableID).fullName
                              }"),
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshotTask.hasError) {
                return const Text("Error");
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        } else if (snapshotAccountable.hasError) {
          return const Text("Error");
        }
        return const Center(
          child: CircularProgressIndicator(),
        );

      },
    );
  }

}