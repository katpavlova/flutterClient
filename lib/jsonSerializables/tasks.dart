
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../main.dart';

part 'tasks.g.dart';


String IP_ADDRESS = "151.0.50.17";
String PORT = "25565";

@JsonSerializable()
class TasksList{
  List<Task> tasks;
  TasksList({required this.tasks});

  factory TasksList.fromJson(Map<String, dynamic> json) => _$TasksListFromJson(json);

  Map<String, dynamic> toJson() => _$TasksListToJson(this);
}

@JsonSerializable()
class Task{
  @JsonKey(name: "_id")
  final String id;
  final String name;
  final String content;
  final String accontableID;

  Task({required this.id, required this.name, required this.content, required this.accontableID});

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}

Future<TasksList> getTasksList(BuildContext context) async {
  print("getTasksList");
  String access = Provider.of<Auth>(context).accessToken;
  var getRefresh = Provider.of<Auth>(context).getRefresh;
  print("access - $access");
  var url = Uri.parse('http://$IP_ADDRESS:$PORT/api/v2/task');
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $access',
    },
  );
  if(response.statusCode == 401) {
    print("error 401");
    String newAccess = await getRefresh();
    print("newAccess - $newAccess");
    final response2 = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $newAccess',
      },
    );
    if(response2.statusCode == 200) {
      return TasksList.fromJson(json.decode(response2.body));
    } else {
      throw Exception("Error: ${response2.reasonPhrase}");
    }
  }
  if(response.statusCode == 200) {
    return TasksList.fromJson(json.decode(response.body));
  } else {
    throw Exception("Error: ${response.reasonPhrase}");
  }
}

Future<Task> getTask(BuildContext context, String id) async {
  String access = Provider.of<Auth>(context).accessToken;
  var getRefresh = Provider.of<Auth>(context).getRefresh;
  print("access - $access");
  var url = Uri.parse('http://$IP_ADDRESS:$PORT/api/v2/task/$id');
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $access',
    },
  );
  if(response.statusCode == 401) {
    print("error 401");
    String newAccess = await getRefresh();
    print("newAccess - $newAccess");
    final response2 = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $newAccess',
      },
    );
    if(response2.statusCode == 200) {
      return Task.fromJson(json.decode(response2.body));
    } else {
      throw Exception("Error: ${response2.reasonPhrase}");
    }
  }
  if(response.statusCode == 200) {
    return Task.fromJson(json.decode(response.body));
  } else {
    throw Exception("Error: ${response.reasonPhrase}");
  }

}

Future<Task> updateTask(Auth auth, String id, String name, String content, String accontableID) async {
  String access = auth.accessToken;
  var getRefresh = auth.getRefresh;
  print("access - $access");
  var url = Uri.parse('http://$IP_ADDRESS:$PORT/api/v2/task');
  Map<String,String> headers = {
    'Authorization': 'Bearer $access',
    'Content-Type': 'application/json'
  };
  var body = json.encode({
    "_id": "${id}",
    "name": "${name}",
    "content": "${content}",
    "accontableID": "${accontableID}"
  });
  print("body put - $body");
  final response = await http.put(
      url,
      headers: headers,
      body: body
  );
  if(response.statusCode == 401) {
    print("error 401");
    String newAccess = await getRefresh();
    print("newAccess - $newAccess");
    Map<String,String> headers2 = {
      'Authorization': 'Bearer $newAccess',
      'Content-Type': 'application/json'
    };
    final response2 = await http.put(
        url,
        headers: headers2,
        body: body
    );
    if(response2.statusCode == 200) {
      print("response 200");
      return Task.fromJson(json.decode(response2.body));
    } else {
      throw Exception("Error: ${response2.reasonPhrase}");
    }
  }
  if(response.statusCode == 200) {
    print("response 200");
    return Task.fromJson(json.decode(response.body));
  } else {
    throw Exception("Error: ${response.reasonPhrase}");
  }
}

Future<Task> deleteTask(Auth auth, String id) async {
  String access = auth.accessToken;
  var getRefresh = auth.getRefresh;
  print("access - $access");
  var url = Uri.parse('http://$IP_ADDRESS:$PORT/api/v2/task/$id');
  final response = await http.delete(
    url,
    headers: {
      'Authorization': 'Bearer $access',
    },
  );
  if(response.statusCode == 401) {
    print("error 401");
    String newAccess = await getRefresh();
    print("newAccess - $newAccess");
    final response2 = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $newAccess',
      },
    );
    if(response2.statusCode == 200) {
      return Task.fromJson(json.decode(response2.body));
    } else {
      throw Exception("Error: ${response2.reasonPhrase}");
    }
  }
  if(response.statusCode == 200) {
    return Task.fromJson(json.decode(response.body));
  } else {
    throw Exception("Error: ${response.reasonPhrase}");
  }

}

Future<Task> createTask(Auth auth, String name, String content, String accontableID) async {
  String access = auth.accessToken;
  var getRefresh = auth.getRefresh;
  print("access - $access");
  var url = Uri.parse('http://$IP_ADDRESS:$PORT/api/v2/task');
  Map<String,String> headers = {
    'Authorization': 'Bearer $access',
    'Content-Type': 'application/json'
  };
  var body = json.encode({
    "name": "${name}",
    "content": "${content}",
    "accontableID": "${accontableID}"
  });
  print("body create - $body");
  final response = await http.post(
      url,
      headers: headers,
      body: body
  );
  if(response.statusCode == 401) {
    print("error 401");
    String newAccess = await getRefresh();
    print("newAccess - $newAccess");
    Map<String,String> headers2 = {
      'Authorization': 'Bearer $newAccess',
      'Content-Type': 'application/json'
    };
    final response2 = await http.put(
        url,
        headers: headers2,
        body: body
    );
    if(response2.statusCode == 200) {
      print("response 200");
      return Task.fromJson(json.decode(response2.body));
    } else {
      throw Exception("Error: ${response2.reasonPhrase}");
    }
  }
  if(response.statusCode == 200) {
    print("response 200");
    return Task.fromJson(json.decode(response.body));
  } else {
    throw Exception("Error: ${response.reasonPhrase}");
  }
}