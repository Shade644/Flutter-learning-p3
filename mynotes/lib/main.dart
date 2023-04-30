import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/views/login_view.dart';
import 'firebase_options.dart';

void main() {
  runApp(
     MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
    
        primarySwatch: Colors.blue, 
      ),
      home: const HomePage(),
    )
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
      title: Text('Home Page'),
      ), 
      body: FutureBuilder(
          future: Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                  ),

        builder: (context, snapshot)  {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user?.emailVerified ?? false){
              print('ok');
              return const Text('Done');
            }
            else{
              print('brak weryfikacji');
           return const VerifyEmailView();
            }
          // return const LoginView(title: '',);
                 default:
                  return const Text('Loading');
          }
        },
        
      ),
    );
  }
}

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return  Column(children: [
          Text('Zweryfikuj konto'),
          TextButton(onPressed: () {
            final user = FirebaseAuth.instance.currentUser;
            user?.sendEmailVerification();
          }, 
          child: Text('Wyślij Email Weryfikacyjnyjny'))
        ],
        );
  }
}
