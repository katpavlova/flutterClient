import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../jsonSerializables/accountables.dart';
import '../../main.dart';

class AccountableItemStateFull extends StatefulWidget{
  final id;
  const AccountableItemStateFull(this.id, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _AccountableItemState();
  }
}

class _AccountableItemState extends State<AccountableItemStateFull>{
  late Future<Accountable> position = getAccountable(context, widget.id);
  bool _loading = false;

  final _formKey = GlobalKey<FormState>();

  final _idController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();


  String _id = "";
  String _fullName = "";
  String _phone = "";
  String _email = "";

  @override
  void initState(){
    super.initState();

    // position = getPosition(context, widget.id);
    // getPosition(context, widget.id).then((value) => {
    //   print("then value - $value")
    // });
  }

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);
    var user = Provider.of<Auth>(context).user;
    return FutureBuilder(
      future: position,
      builder: (context, snapshot){
        // print(snapshot.data);
      if (snapshot.hasData){
        _id = snapshot.data!.id;
        _fullNameController.text = snapshot.data!.fullName;
        _phoneController.text = "${snapshot.data!.phone}";
        _emailController.text = snapshot.data!.email;
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
                      _fullName = value!;
                    },
                  // inputFormatters: [
                  //   LengthLimitingTextInputFormatter(30),
                  // ],
                  // controller: _nameController,
                  // maxLength: 30,
                  initialValue: "${snapshot.data?.fullName}",
                  decoration: const InputDecoration(
                      labelText: "ФИО *",
                      prefixIcon: Icon(Icons.person),
                      // suffixIcon: Icon(
                      //   Icons.delete_outline,
                      //   color: Colors.red,
                      // )
                  ),
                  validator: (val) => _validateName(val!),
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  onSaved: (value) {
                    _phone = value!;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  // controller: _salaryController,
                  // maxLength: 30,
                  initialValue: "${snapshot.data?.phone}",
                  decoration: const InputDecoration(
                      labelText: "Телефон *",
                      prefixIcon: Icon(Icons.phone),
                      // suffixIcon: Icon(
                      //   Icons.delete_outline,
                      //   color: Colors.red,
                      // )
                  ),
                  validator: (val) => _validatePhone(val!),
                ),
                TextFormField(
                  onSaved: (value) {
                    _email = value!;
                  },
                  // inputFormatters: [
                  //   LengthLimitingTextInputFormatter(30),
                  // ],
                  // controller: _salaryController,
                  // maxLength: 30,
                  initialValue: "${snapshot.data?.email}",
                  decoration: const InputDecoration(
                      labelText: "Почта *",
                      prefixIcon: Icon(Icons.mail),
                      // suffixIcon: Icon(
                      //   Icons.delete_outline,
                      //   color: Colors.red,
                      // )
                  ),
                  validator: (val) => _validateEmail(val!),
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
                        print("id - $_id, name - $_fullName, phone - $_phone, email - $_email");
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
                // Text("${snapshot.data?.id}"),
                Text(
                  "ФИО: ${snapshot.data?.fullName}",
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700
                  ),
                ),
                const SizedBox(height: 10,),
                Text(
                  "Телефон: ${snapshot.data?.phone}",
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700
                  ),
                ),
                const SizedBox(height: 10,),
                Text(
                  "Почта: ${snapshot.data?.email}",
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400
                  ),
                )
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
      int tmpPhone = int.parse(_phone);
      Accountable accountableData = await updateAccountable(auth, _id, _fullName, tmpPhone, _email);
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
      print("Name: ${_fullNameController.text}");
      print("Phone: ${_phoneController.text}");
      print("Email: ${_emailController.text}");
      Accountable accountableData = await deleteAccountable(auth, _id);
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

  String? _validatePhone(String value){
    if (value.isEmpty){
      return "Обязательное поле";
    }
    return null;
  }

  String? _validateEmail(String value){
    if (value.isEmpty){
      return "Обязательное поле";
    }
    return null;
  }
}