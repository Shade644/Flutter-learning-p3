import 'package:flutter/material.dart';
import 'package:mynotes/constants/router.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import '../utilities/show_error.dart';


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
                    await AuthService.firebase().logIn(
                      email: email, 
                      password: password
                      );
                    final user = AuthService.firebase().currentUser;
                    if(user?.isEmailVerified ?? false){
                      Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                    }
                    else{
                      Navigator.of(context).pushNamedAndRemoveUntil(verifyemailRoute, (route) => false);
                    }
                  } 
                  on UserNotFoundAuthException{
                      await showErrorDialog(context, 'Użytkownik nie istnieje');
                  }
                  on WrongPasswordAuthException{
                     await showErrorDialog(context,'Złe hasło');
                  }
                  on GenericAuthException{
                     await showErrorDialog(context,'Błąd');
                  }
                },
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (Route <dynamic> route) => false);
                },
                child: const Text('Rejestracja'),
              )
            ],
          ),
     );
        }
}