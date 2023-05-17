import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class Authorization extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var accessToken = Provider.of<Auth>(context).accessToken;
    var refreshToken = Provider.of<Auth>(context).refreshToken;
    var auth = Provider.of<Auth>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
          title: const Text(
            "Tasks App",
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 20, bottom: 20),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Приложение для учета задач",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "/accountables");
                      },
                      child: const Text(
                          "Ответственные"
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "/tasks");
                      },
                      child: const Text(
                          "Задачи"
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple
                ),
                onPressed: () {
                  auth.clearData();
                },
                child: const Text(
                    "Выход из аккаунта"
                ),
              ),
            ],
          ),
        )
    );
  }

}