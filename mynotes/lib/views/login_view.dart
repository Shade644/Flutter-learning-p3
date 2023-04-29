import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';


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
      appBar: AppBar(
      title: Text('Login'),
      ), 
      body: FutureBuilder(
          future: Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                  ),

        builder: (context, snapshot)  {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              break;
          }
          return Column(
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
                } 
                on FirebaseAuthException catch (err){
                  if (err.code =='user-not-found'){
                    print('Użytkownik nie istnieje');
                  }
                  else if(err.code == 'wrong-password'){
                    print('Złe hasło');

                  }

                }
                
              
              },
              child: const Text('Login'),
            ),
          ],
        );
        // default:
        // return const Text('Loading');
        },
        
      ),
    );
  }
  }

 
