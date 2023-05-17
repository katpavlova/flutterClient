import 'package:flutter/material.dart';

import 'Statefull/AccountableAddStateFull.dart';

class AccountableAdd extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text(
          "Добавление ответственного"
        ),
      ),
      body: AccountableAddStateFull(context),
    );
  }

}