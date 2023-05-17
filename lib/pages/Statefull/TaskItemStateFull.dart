import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../jsonSerializables/tasks.dart';
import '../../jsonSerializables/accountables.dart';
import '../../main.dart';

class TaskItemStateFull extends StatefulWidget{
  final id;
  const TaskItemStateFull(this.id, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _TaskItemState();
  }

}

class _TaskItemState extends State<TaskItemStateFull>{
  late Future<AccountablesList> accountablesList = getAccountablesList(context);
  late Future<Task> task = getTask(context, widget.id);
  bool _loading = false;

  // List<String> _selected = [];
  // Map<String, String> _selected2 = {};

  String _selectedAccountable = "";

  final _formKey = GlobalKey<FormState>();

  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _contextController = TextEditingController();


  String _id = "";
  String _name = "";
  String _content = "";
  String _accontableID = "";


  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);
    var user = Provider.of<Auth>(context).user;

    return FutureBuilder<AccountablesList>(
      future: accountablesList,
      builder: (context, snapshotAccountable){
        if(snapshotAccountable.hasData){
          // for(final e in snapshotPosition.data!.positions){
          //   _selected.add(e.name);
          // }
          return FutureBuilder<Task>(
            future: task,
            builder: (context, snapshotTask){
              if(snapshotTask.hasData){
                _id = snapshotTask.data!.id;
                _accontableID = snapshotTask.data!.accontableID;
                // print(_selected);
                return user.userRole.contains("MODER") ?
                Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.only(top: 20, left: 16, bottom: 16, right: 16),
                    children: [
                      const Text(
                        "Редактирование",
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
                        initialValue: "${snapshotTask.data?.name}",
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
                        initialValue: "${snapshotTask.data?.content}",
                        decoration: const InputDecoration(
                          labelText: "Описание задачи *",
                          prefixIcon: Icon(Icons.file_present),
                          // suffixIcon: Icon(
                          //   Icons.delete_outline,
                          //   color: Colors.red,
                          // ),
                          // border: UnderlineInputBorder()
                        ),
                        validator: (val) => _validateContent(val!),
                      ),
                      // const SizedBox(height: 20,),
                      DropdownButtonFormField(
                        onSaved: (value){
                          _selectedAccountable = value!;
                        },
                        decoration: const InputDecoration(
                          labelText: "Ответственный *",
                          prefixIcon: Icon(
                            Icons.work,
                            color: Colors.grey,
                          )
                        ),
                        items: snapshotAccountable.data!.accountables.map((e) {
                          return DropdownMenuItem(
                            value: e.id,
                            child: Text(e.fullName),
                          );
                        }).toList(),
                        onChanged: (data){
                          print(data);
                          setState(() {
                            // _selectedPosition = data!;
                            _accontableID = data!;
                          });
                        },
                        // value: "Директор",
                        value: snapshotAccountable.data!.accountables.firstWhere((element) => element.id==snapshotTask.data!.accontableID).id,
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
                            print("id - $_id, name - $_name, content - $_content, accontableID - $_accontableID, selectedAccountable - $_selectedAccountable");
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
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(1000, 40),
                            backgroundColor: Colors.red
                        ),
                        onPressed: () async {
                          var tmp = await _submitForm2(auth);
                          if(tmp == true){
                            bool tmp = true;
                            Navigator.pop(context, tmp);
                          }
                          // Navigator.pop(context);

                        },
                        child: const Text(
                            "Удалить"
                        ),
                      ),
                    ],
                  ),
                ) :
                Container(
                  padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Название задачи: ${snapshotTask.data?.name}",
                        style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      Text(
                        "Описание задачи: ${snapshotTask.data?.content}",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      Text(
                        "Ответственный: ${snapshotAccountable.data?.accountables.firstWhere((element) => element.id == snapshotTask.data?.accontableID).fullName}",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ),
                );

              } else if (snapshotTask.hasError) {
                return const Text("Error");
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          );
        } else if (snapshotAccountable.hasError) {
          return const Text("Error");
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }

  Future<dynamic> _submitForm(Auth auth) async {
    try{
      // int tmpPhone = int.parse(_phone);
      Task taskData = await updateTask(auth, _id, _name, _content, _selectedAccountable);
      return true;
      // authData
    }catch(e){
      return false;
    }
  }

  Future<dynamic> _submitForm2(Auth auth) async {
    if (_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      print("Форма валидна");
      // print("Name: ${_nameController.text}");
      // print("Salary: ${_salaryController.text}");
      Task taskData = await deleteTask(auth, _id);
      return true;
    }
    return false;
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