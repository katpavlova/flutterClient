import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/pages/TaskAdd.dart';
import 'package:untitled2/pages/TaskItem.dart';
import 'package:untitled2/pages/Tasks.dart';
import 'package:untitled2/pages/Index.dart';
import 'package:untitled2/pages/Login.dart';
import 'package:untitled2/pages/AccountableAdd.dart';
import 'package:untitled2/pages/AccountableItem.dart';
import 'package:untitled2/pages/Accountables.dart';
import 'package:untitled2/pages/Registration.dart';

import 'jsonSerializables/auths.dart';

// import './pages/Stateless/MyFirstApp.dart';
// import './pages/Stateless/Second.dart';

void main() => runApp(const Main());

class Main extends StatelessWidget{
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    var auth = Auth();

    // int a = 2;
    return MultiProvider(
      providers: [
        // Provider(create: (context) => Auth),
        ChangeNotifierProvider(create: (context) => auth),
        // ChangeNotifierProvider(create: (context) => auth.user)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: MyFirstApp(),
        initialRoute: "/",
        routes: {

          "/": (context) => const Index(),
          "/registration": (context) => const Registration(),
          "/login": (context) => Login(),
          "/accountables": (context) => Accountables(),
          "/accountableItem": (context) => AccountableItem(),
          "/accountableAdd": (context) => AccountableAdd(),
          "/tasks": (context) => Tasks(),
          "/taskItem": (context) => TaskItem(),
          "/taskAdd": (context) => TaskAdd(),
        },
      ),
    );
  }
}

class Auth extends ChangeNotifier {
  String accessToken = "";
  var refreshToken= "";
  User user = User(userId: "", userRole: []);

  Auth(){
    // refreshToken = readFromFile("refreshToken");
    // print("object - $refreshToken");
    // accessToken = readFromFile("accessToken");
    // print("object - $accessToken");
    SharedPreferences.getInstance().then((prefs) {
      // ignore: avoid_print
      print("keys constructor - ${prefs.getKeys()}");
      // ignore: avoid_print
      print("keys accessToken - ${prefs.getString('accessToken')}");
      // ignore: avoid_print
      print("keys refreshToken - ${prefs.getString('refreshToken')}");
      accessToken = prefs.getString('accessToken') ?? "";
      refreshToken = prefs.getString('refreshToken') ?? "";
      user.userId = prefs.getString('userId') ?? "";
      user.userRole = prefs.getStringList('userRole') ?? [];
      // ignore: avoid_print
      print("keys constructor accessToken - $accessToken");
      // ignore: avoid_print
      print("keys constructor refreshToken - $refreshToken");

      notifyListeners();
    });
  }

  Future<String> getRefresh() async{
    // ignore: avoid_print
    print("getRefresh start");
    var auth = await getNewTokens(refreshToken);
    // ignore: avoid_print
    print("getRefresh response");
    // ignore: avoid_print
    print("auth.accessToken ${auth.accessToken}");
    // ignore: avoid_print
    print("auth.refreshToken ${auth.refreshToken}");
    // ignore: avoid_print
    print("auth.user ${auth.user.userRole}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // ignore: avoid_print
    print("keys1 - ${prefs.getKeys()}");

    prefs.setString('accessToken', auth.accessToken);
    accessToken = auth.accessToken;
    // ignore: avoid_print
    print("getRefresh accessToken - $accessToken");

    prefs.setString('refreshToken', auth.refreshToken);
    refreshToken = auth.refreshToken;
    // ignore: avoid_print
    print("getRefresh refreshToken - $refreshToken");

    prefs.setString('userId', auth.user.userId);
    prefs.setStringList('userRole', auth.user.userRole);
    user = auth.user;

    // ignore: avoid_print
    print("keys2 - ${prefs.getKeys()}");
    // writeToFile("accessToken", auth.accessToken);
    // writeToFile("refreshToken", auth.refreshToken);
    // user = auth.user;
    // accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY0NTU0NzFiNWU5Njg5ZWY1ZDgyMzFmMSIsInJvbGVzIjpbIlVTRVIiXSwiaWF0IjoxNjgzMzk4MTMwLCJleHAiOjE2ODM0MDE3MzB9.QJEwzERmQ6gDp3TA72dhda23gYfPzA_FohicWrw79ns";
    // refreshToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY0NTU0NzFiNWU5Njg5ZWY1ZDgyMzFmMSIsInJvbGVzIjpbIlVTRVIiXSwiaWF0IjoxNjgzMzk4MTMwLCJleHAiOjE2ODM0ODQ1MzB9.2ICv3Ua5XA2S9ugdWKMrBF0YGwuThekuna7mXR2K--M";
    // ignore: avoid_print
    print("getRefresh end");
    notifyListeners();
    return auth.accessToken;
  }

  void clearData() {
    SharedPreferences.getInstance().then((prefs) {
      print("========== prefs clear start ==========");
      prefs.clear();
      accessToken = "";
      refreshToken = "";
      user.userId = "";
      user.userRole = [];
      print("========== prefs clear end ==========");

    });

    notifyListeners();
  }

  Future<bool> addData(String accessData, String refreshData, String userId, List<String> userRole) async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // ignore: avoid_print
      print("keys1 addData - ${prefs.getKeys()}");
      prefs.setString('accessToken', accessData);
      accessToken = accessData;

      prefs.setString('refreshToken', refreshData);
      refreshToken = refreshData;


      prefs.setString('userId', userId);
      user.userId = userId;
      prefs.setStringList('userRole', userRole);
      user.userRole = userRole;

      notifyListeners();
      return true;
    } catch(e){
      print(e);
      return false;
    }
  }

// void writeToFile(String key, dynamic value) {
//   final file = File('/$key.json');
//   final contents = {key: value};
//   const encoder = JsonEncoder.withIndent('  ');
//   final prettyPrinted = encoder.convert(contents);
//   file.writeAsStringSync(prettyPrinted);
// }
//
// String readFromFile(String key) {
//   final file = File('/$key.json');
//   try {
//     final contents = file.readAsStringSync();
//     const decoder = JsonDecoder();
//     final parsed = decoder.convert(contents);
//     return parsed[key];
//   } on FileSystemException {
//     // ignore: avoid_print
//     print("File not found");
//     final contents = '{"$key": ""}';
//     const decoder = JsonDecoder();
//     final parsed = decoder.convert(contents);
//     return parsed[key];
//   }
// }
}







