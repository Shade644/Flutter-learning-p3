import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer';


class LoginView extends StatefulWidget {
  const LoginView({super.key, required this.title});


  final String title;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
 late final TextEditingController _email;
  late final TextEditingController _password;
  
 
  @override
 void initState() {
  _email =TextEditingController();
  _password=TextEditingController();
  super.initState();
 }
   @override
 void dispose() {
  _email.dispose();
  _password.dispose();
  super.dispose();
 }
  
  @override
  Widget build(BuildContext context) {
   
     return Scaffold(
      appBar: AppBar(title: const Text('Logowanie'),),
       body: Column(
            children: [
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration:  const InputDecoration(
                  hintText: "Enter your email",
                ),
                ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration:  const InputDecoration(
                  hintText: "Enter your password ",
                ),
              ),
              TextButton(
                onPressed: () async{
                  final email = _email.text;
                  final password = _password.text;
                  //FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: password)
                  try{
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email, 
                    password: password,
                    );
                   Navigator.of(context).pushNamedAndRemoveUntil('/notes/', (route) => false);
                  } 
                  on FirebaseAuthException catch (err){
                    if (err.code =='user-not-found'){
                      log('Użytkownik nie istnieje');
                    }
                    else if(err.code == 'wrong-password'){
                      log('Złe hasło');
     
                    }
                  }
                },
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('/register/', (Route <dynamic> route) => false);
                },
                child: const Text('Rejestracja'),
              )
            ],
          ),
     );
        }
}
