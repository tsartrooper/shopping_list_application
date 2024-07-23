import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/widgets/new_item.dart';
import 'package:shop_app/models/grocery_item.dart';

import 'grocery_list.dart';



class logUser extends StatefulWidget{
  const logUser({super.key});

  State<logUser> createState() => _logUserState();
}

class _logUserState extends State<logUser>{
  final _formKey = GlobalKey<FormState>();
  var enteredName = '';
  var enteredPassword = '';

  void _saveUser() async {
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();

      final url = Uri.http('10.0.2.2:5005', '/login.json');
      final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_name': enteredName,
          'password': enteredPassword
        },),);

      if(response.statusCode == 200 || response.statusCode == 201){
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(response.body);
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => GroceryList(authentication_key: responseData['access_token'])));
      }
      else{
        print(response.statusCode);
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
          title: const Text('user login up'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                  children: [
                    TextFormField(
                      maxLength: 50,
                      decoration: const InputDecoration(
                        label: Text('Name'),
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty ){
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
                              label: Text('Password'),
                            ),
                            validator: (value){
                              if(value == null || value.isEmpty){
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
                              child: Text("Log in"))
                        ]
                    )
                  ]
              ),
            )
        )
    );
  }
}