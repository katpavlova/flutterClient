import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../jsonSerializables/accountables.dart';
import '../../main.dart';

// ignore: must_be_immutable
class Accountable extends StatefulWidget{
  // String access;
  // var getRefresh;
  BuildContext context;
  Accountable(this.context, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _AccountableState();
  }
}

class _AccountableState extends State<Accountable>{
  late Future<AccountablesList> accountablesList;
  bool load = false;

  @override
  void initState(){
    super.initState();
    // print("access = ${Provider.of<Auth>(context).accessToken}");

    accountablesList = getAccountablesList(widget.context);

    // print("positionsList - ${positionsList.then((value) => null)}");
    // positionsList.then((value) => {
    //   if (value == "Instance of 'PositionsList'") {
    //     print("reload access and refresh")
    //   }
    // });
    // positionsList
    // print("$positionsList");
    // if()
  }

  @override
  Widget build(BuildContext context) {
    // String access = Provider.of<Auth>(context).accessToken;
    // positionsList = getPositionsList(widget.context);
    return FutureBuilder<AccountablesList>(
      future: accountablesList,
      builder: (context, snapshot) {
        if (snapshot.hasData){
          // snapshot.data?.positions[0].name = "hi";
          return ListView.builder(
            itemCount: snapshot.data?.accountables.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async{
                  final result = await Navigator.pushNamed(context, "/accountableItem", arguments: {
                    "id": "${snapshot.data?.accountables[index].id}"
                  });
                  print("result - $result");
                  if(result != null){
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/accountables");
                  }
                },
                child: Card(
                  child: ListTile(
                    title: Text("${snapshot.data?.accountables[index].fullName}"),
                    subtitle: Text("${snapshot.data?.accountables[index].phone}"),
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Text("Error");
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}