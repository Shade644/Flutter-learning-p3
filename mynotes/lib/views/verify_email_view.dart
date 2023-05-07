import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/router.dart';


class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weryfikacja email"),),
      body: Column(children: [
            const Text('Wejdz na swojego email i potwierdz konto'),
            TextButton(onPressed: () {
              final user = FirebaseAuth.instance.currentUser;
              user?.sendEmailVerification();
            }, 
            child: const Text('Wyślij Email Weryfikacyjnyjny Ponownie'),
            ),
            TextButton
            (onPressed: () async {
             await FirebaseAuth.instance.signOut();
             Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false,);
            }, child: const Text('Restart')
            ,)
          ],
          ),
    );
  }
}
