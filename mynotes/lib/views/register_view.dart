import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:mynotes/constants/router.dart';

import '../utilities/show_error.dart';



class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}
class _RegisterViewState extends State<RegisterView> {
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
    appBar: AppBar(title: const Text('Register'),),
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
                  try{
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email, 
                    password: password,
                    );
                    final user = FirebaseAuth.instance.currentUser;
                    await user?.sendEmailVerification();
                    Navigator.of(context).pushNamed(verifyemailRoute);
                  }
                  on FirebaseAuthException catch (err){
                    if (err.code == 'weak-password'){
                        await showErrorDialog(context,'Słabe Hasło',);
                    }
                    else if (err.code == 'email-already-in-use'){
                        await showErrorDialog(context,'Email jest w użyciu',);
                    }
                    else if (err.code == 'invalid-email'){
                       await showErrorDialog(context,'Zły email',);
                    }
                    else {
                      await showErrorDialog(context, 'Error: ${err.code}');
                    }
                  } 
                    catch(err){
                      await showErrorDialog(context, err.toString(),);
                    }
                            
                },
                child: const Text('Register'),
              ),
               TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (Route <dynamic> route) => false);
              },
              child: const Text('Masz konto zaloguj się'),
            )
            ],
          ),
   );
        }
  }
