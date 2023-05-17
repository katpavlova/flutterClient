
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../jsonSerializables/tasks.dart';
import '../../jsonSerializables/accountables.dart';
import '../../main.dart';

class TaskAddStateFull extends StatefulWidget{
  BuildContext context;
  TaskAddStateFull(this.context, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _TaskAddState();
  }

}

class _TaskAddState extends State<TaskAddStateFull>{
  late Future<AccountablesList> accountablesList = getAccountablesList(context);
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String _id = "";
  String _name = "";
  String _content = "";
  String _accontableID = "";
  String _selectedAcccountable = "";
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);
    var user = Provider.of<Auth>(context).user;

    return FutureBuilder<AccountablesList>(
      future: accountablesList,
      builder: (context, snapshot){
        if(snapshot.hasData){
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.only(top: 20, left: 16, bottom: 16, right: 16),
              children: [
                const Text(
                  "Добавление",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30
                  ),
                ),
                const SizedBox(height: 16,),
                TextFormField(
                  onSaved: (value) {
                    _name = value!;
                  },
                  // inputFormatters: [
                  //   LengthLimitingTextInputFormatter(30),
                  // ],
                  // controller: _nameController,
                  // maxLength: 30,
                  // initialValue: "${snapshotEmployee.data?.fullName}",
                  decoration: const InputDecoration(
                      labelText: "Название задачи *",
                      prefixIcon: Icon(Icons.task),
                      // suffixIcon: Icon(
                      //   Icons.delete_outline,
                      //   color: Colors.red,
                      // )
                  ),
                  validator: (val) => _validateName(val!),
                ),
                TextFormField(
                  maxLines: 3,
                  onSaved: (value) {
                    _content = value!;
                  },
                  // inputFormatters: [
                  //   LengthLimitingTextInputFormatter(30),
                  // ],
                  // controller: _salaryController,
                  // maxLength: 30,
                  // initialValue: "${snapshotEmployee.data?.phone}",
                  decoration: const InputDecoration(
                      labelText: "Описание задачи *",
                      prefixIcon: Icon(Icons.file_present),
                      // suffixIcon: Icon(
                      //   Icons.delete_outline,
                      //   color: Colors.red,
                      // )
                  ),
                  validator: (val) => _validateContent(val!),
                ),
                // const SizedBox(height: 20,),
                DropdownButtonFormField(
                  onSaved: (value){
                    // _selectedPosition = value!;
                  },
                  decoration: const InputDecoration(
                      labelText: "Ответственный *",
                      prefixIcon: Icon(
                        Icons.work,
                        color: Colors.grey,
                      )
                  ),
                  items: snapshot.data!.accountables.map((e) {
                    return DropdownMenuItem(
                      value: e.id,
                      child: Text(e.fullName),
                    );
                  }).toList(),
                  onChanged: (data){
                    print(data);
                    setState(() {
                      _selectedAcccountable = data!;
                      // _positionID = data!;
                    });
                  },
                  validator: (val) {
                    return val == null ? "Обязательное поле" : null;
                  },
                  // value: "Директор",
                  // value: snapshotPosition.data!.positions.firstWhere((element) => element.id==snapshotEmployee.data!.positionID).id,
                ),
                const SizedBox(height: 20,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(1000, 40),
                      backgroundColor: Colors.deepPurple
                  ),
                  onPressed: () async {
                    setState(() {
                      _loading = true;
                    });
                    if (_formKey.currentState!.validate()){
                      _formKey.currentState!.save();
                      print("id - $_id, name - $_name, content - $_content, accontableID - $_accontableID, selectedAcccountable - $_selectedAcccountable");
                      var tmp = await _submitForm(auth);
                      if(tmp == true){
                        bool tmp = true;
                        Navigator.pop(context, tmp);
                      }
                    }
                  },
                  child: const Text(
                      "Сохранить"
                  ),
                ),
                // const SizedBox(height: 6,),
              ],
            ),
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

  Future<dynamic> _submitForm(Auth auth) async {
    try{
      // int tmpPhone = int.parse(_phone);
      Task taskData = await createTask(auth, _name, _content, _selectedAcccountable);
      return true;
      // authData
    }catch(e){
      return false;
    }
  }

  Future<dynamic> _submitForm2(Auth auth) async {
    // if (_formKey.currentState!.validate()){
    //   _formKey.currentState!.save();
    //   print("Форма валидна");
    //   print("Name: ${_nameController.text}");
    //   print("Salary: ${_salaryController.text}");
    //   Position positionData = await deletePosition(auth, _id);
    //   return true;
    // }
    // return false;
  }

  String? _validateName(String value){
    if (value.isEmpty){
      return "Обязательное поле";
    }
    return null;
  }

  String? _validateContent(String value){
    if (value.isEmpty){
      return "Обязательное поле";
    }
    return null;
  }
}