import 'package:flutter/material.dart';
import 'package:mynotes/constants/router.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/notes/note_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
import 'package:path/path.dart';
import 'notes/new_notes_view.dart';

void main() {
  runApp(
     MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
    
        primarySwatch: Colors.blue, 
      ),
      home: const HomePage(),
      routes: {
        loginRoute:(context) => const LoginView(title: '',),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyemailRoute: (context) => const VerifyEmailView(),
        newnotesRoute: (context) => const NewNotesView(),
      },
    )
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    
   return FutureBuilder(
          future: AuthService.firebase().initialize(),

        builder: (context, snapshot)  {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if(user != null){
            if(user.isEmailVerified){
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
