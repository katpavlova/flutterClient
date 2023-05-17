import 'package:flutter/material.dart';
import 'package:untitled2/pages/Statefull/AccountableItemStateFull.dart';

class AccountableItem extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    print(args);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Описание ответственного"
        ),
      ),
      body: AccountableItemStateFull(args["id"]),
    );
  }

}