import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


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
            const Text('Zweryfikuj konto'),
            TextButton(onPressed: () {
              final user = FirebaseAuth.instance.currentUser;
              user?.sendEmailVerification();
            }, 
            child: const Text('Wyślij Email Weryfikacyjnyjny'))
          ],
          ),
    );
  }
}
