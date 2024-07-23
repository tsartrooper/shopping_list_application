import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/widgets/UserLogin.dart';



class newUser extends StatefulWidget{
  const newUser({super.key});

  State<newUser> createState() => _NewUserState();
}

class _NewUserState extends State<newUser>{
  final _formKey = GlobalKey<FormState>();
  var enteredName = '';
  var enteredPassword = '';
  
  void _saveUser() async {
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();

      // print("-\")

      final url = Uri.https('127.0.0.1:5005', '/register.json');
      final response = await http.post(Uri.http('10.0.2.2:5005', '/register.json'),
        headers: {
        'Content-Type': 'application/json',
      },
        body: jsonEncode({
        "user_name": enteredName,
        "password": enteredPassword,
        },),);


      print('whats goin on?');
      print(response.statusCode);

      if(response.statusCode == 200 || response.statusCode == 201){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => const logUser()),
        );
      }
      else{
        _resetUser();
      }
    }
  }

  void _resetUser(){
    _formKey.currentState!.reset();
  }


  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('user sign up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
            TextFormField(
            maxLength: 50,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              label: Text('Name'),
            ),
            validator: (value){
              if(value == null || value.isEmpty || value.trim().length <= 1 || value.trim().length >= 50){
                return 'the length must be between 2 to 50';
              }
              return null;
            },
            onSaved:  (value){
              enteredName = value!;
            } ,
          ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Quantity'),
                    ), 
                    validator: (value){
                      if(value == null || value.isEmpty
                          || value == null){
                        return 'the length must be between 2 to 50';
                      }
                    },
                    onSaved: (value){
                      enteredPassword= value!;
                    },
                  ),
                  ),
            ]
          ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children:[
                    TextButton(onPressed: (){
                      _resetUser();
                    }, child: Text('Reset')),
                    ElevatedButton(onPressed: (){
                      _saveUser();
                    },
                        child: Text("Sign up")),
                    ElevatedButton(onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => const logUser()),
                      );
                    },
                        child: Text("Already have an account?"))
                  ]
              )
                ]
                ),
        )        
    )
    );
  }
}