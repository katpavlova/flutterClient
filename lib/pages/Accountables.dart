
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/jsonSerializables/auths.dart';

import '../main.dart';
import 'Statefull/Accountable.dart';

class Accountables extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<Auth>(context).user;
    // print("user.userRole - ${user}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text(
          "Ответственные"
        ),
      ),
      body: Accountable(context),
      floatingActionButton: user.userRole.contains("MODER") ? FloatingActionButton(
        onPressed: () async{
          final result = await Navigator.pushNamed(context, "/accountableAdd");
          print("result - $result");
          if(result != null){
            Navigator.pop(context);
            Navigator.pushNamed(context, "/accountables");
          }
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ) : null,
    );
  }

}
