import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
import 'firebase_options.dart';
import 'dart:developer';

void main() {
  runApp(
     MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
    
        primarySwatch: Colors.blue, 
      ),
      home: const HomePage(),
      routes: {
        '/login/':(context) => const LoginView(title: '',),
        '/register/': (context) => const RegisterView(),
        '/notes/': (context) => const NotesView(),
      },
    )
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    
   return FutureBuilder(
          future: Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                  ),

        builder: (context, snapshot)  {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if(user != null){
            if(user.emailVerified){
              print('Email is verify');
            }
            else {
              return const VerifyEmailView();
            }
            }
            else{
              return const LoginView(title: '',);
            }
          // return const Text('Gotowe');
          return const NotesView();
                 default:
                  return const Text('Loading');
          }
        },
        
      );
  }
}

enum MenuAction {
  logout
}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Twoje Notatki'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value){
                
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout){
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil('/login/', (_) => false,);
                  }
              }
          }, itemBuilder: (context) {
            return[
                 const PopupMenuItem<MenuAction>(
              value: MenuAction.logout, 
            child: Text('Log out'),
            ),
            ];      
          },)
        ],
      ),
      body:const Text('TEST'),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context){
 return showDialog<bool>(
  context: context, 
  builder: (context) {
    return AlertDialog(
      title: const Text('Sing out'),
      content: const Text('Jesteś pewnien że chcesz sie wylogować?'),
      actions: [
        TextButton (onPressed: () {
          Navigator.of(context).pop(false);
        }, child: const Text('Anuluj')),
        TextButton (onPressed: () {
          Navigator.of(context).pop(true);
        }, child: const Text('Wyloguj się'),)            
      ],
    );
  }
  ).then((value) => (value) ?? false);
}