// import './PositionModel.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../main.dart';

part 'accountables.g.dart';

String IP_ADDRESS = "151.0.50.17";
String PORT = "25565";

@JsonSerializable()
class AccountablesList{
  List<Accountable> accountables;
  AccountablesList({required this.accountables});

  factory AccountablesList.fromJson(Map<String, dynamic> json) => _$AccountablesListFromJson(json);

  Map<String, dynamic> toJson() => _$AccountablesListToJson(this);
}

@JsonSerializable()
class Accountable {
  @JsonKey(name: "_id")
  final String id;
  final String fullName;
  final int phone;
  final String email;

  Accountable({required this.id, required this.fullName, required this.phone, required this.email});

  factory Accountable.fromJson(Map<String, dynamic> json) => _$AccountableFromJson(json);

  Map<String, dynamic> toJson() => _$AccountableToJson(this);
}

Future<AccountablesList> getAccountablesList(BuildContext context) async {
  String access = Provider.of<Auth>(context).accessToken;
  var getRefresh = Provider.of<Auth>(context).getRefresh;
  print("access - $access");
  var url = Uri.parse('http://$IP_ADDRESS:$PORT/api/v2/accountable');
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
      return AccountablesList.fromJson(json.decode(response2.body));
    } else {
      throw Exception("Error: ${response2.reasonPhrase}");
    }
  }
  if(response.statusCode == 200) {
    return AccountablesList.fromJson(json.decode(response.body));
  } else {
    throw Exception("Error: ${response.reasonPhrase}");
  }
}

Future<Accountable> getAccountable(BuildContext context, String id) async {
  String access = Provider.of<Auth>(context).accessToken;
  var getRefresh = Provider.of<Auth>(context).getRefresh;
  print("access - $access");
  var url = Uri.parse('http://$IP_ADDRESS:$PORT/api/v2/accountable/$id');
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
      return Accountable.fromJson(json.decode(response2.body));
    } else {
      throw Exception("Error: ${response2.reasonPhrase}");
    }
  }
  if(response.statusCode == 200) {
    return Accountable.fromJson(json.decode(response.body));
  } else {
    throw Exception("Error: ${response.reasonPhrase}");
  }

}

Future<Accountable> updateAccountable(Auth auth, String id, String fullName, int phone, String email) async {
  String access = auth.accessToken;
  var getRefresh = auth.getRefresh;
  print("access - $access");
  var url = Uri.parse('http://$IP_ADDRESS:$PORT/api/v2/accountable');
  Map<String,String> headers = {
    'Authorization': 'Bearer $access',
    'Content-Type': 'application/json'
  };
  var body = json.encode({
    "_id": "${id}",
    "fullName": "${fullName}",
    "phone": phone,
    "email": "${email}"
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
      return Accountable.fromJson(json.decode(response2.body));
    } else {
      throw Exception("Error: ${response2.reasonPhrase}");
    }
  }
  if(response.statusCode == 200) {
    print("response 200");
    return Accountable.fromJson(json.decode(response.body));
  } else {
    throw Exception("Error: ${response.reasonPhrase}");
  }
}

Future<Accountable> deleteAccountable(Auth auth, String id) async {
  String access = auth.accessToken;
  var getRefresh = auth.getRefresh;
  print("access - $access");
  var url = Uri.parse('http://$IP_ADDRESS:$PORT/api/v2/accountable/$id');
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
      return Accountable.fromJson(json.decode(response2.body));
    } else {
      throw Exception("Error: ${response2.reasonPhrase}");
    }
  }
  if(response.statusCode == 200) {
    return Accountable.fromJson(json.decode(response.body));
  } else {
    throw Exception("Error: ${response.reasonPhrase}");
  }

}

Future<Accountable> createAccountable(Auth auth, String fullName, int phone, String email) async {
  String access = auth.accessToken;
  var getRefresh = auth.getRefresh;
  print("access - $access");
  var url = Uri.parse('http://$IP_ADDRESS:$PORT/api/v2/accountable');
  Map<String,String> headers = {
    'Authorization': 'Bearer $access',
    'Content-Type': 'application/json'
  };
  var body = json.encode({
    "fullName": "${fullName}",
    "phone": phone,
    "email": "${email}"
  });
  print("body put - $body");
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
      return Accountable.fromJson(json.decode(response2.body));
    } else {
      throw Exception("Error: ${response2.reasonPhrase}");
    }
  }
  if(response.statusCode == 200) {
    print("response 200");
    return Accountable.fromJson(json.decode(response.body));
  } else {
    throw Exception("Error: ${response.reasonPhrase}");
  }
}