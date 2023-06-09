import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'main.dart';
import 'utils.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginWidget({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 1),
            TextField(
              controller: emailController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                  labelText: 'Email', labelStyle: TextStyle(fontSize: 12)),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                  labelText: 'Password', labelStyle: TextStyle(fontSize: 12)),
              obscureText: true,
            ),
            const SizedBox(height: 0),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(13),
              ),
              icon: const Icon(Icons.lock_open, size: 24),
              label: const Text(
                'Sign in',
                style: TextStyle(fontSize: 12),
              ),
              onPressed: signIn,
            ),
            const SizedBox(height: 0),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(12),
              ),
              icon: const Icon(Icons.account_circle_rounded, size: 24),
              label: const Text(
                'Guest',
                style: TextStyle(fontSize: 12),
              ),
              onPressed: guest,
            ),
            SizedBox(height: 0),
            RichText(
              text: TextSpan(
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  text: 'Nog geen account?  ',
                  children: [
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignUp,
                        text: 'Maak er een!',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).colorScheme.secondary))
                  ]),
            )
          ],
        ),
      );

  Future signIn() async {
    //showDialog(
    //  context: context,
    //  barrierDismissible: false,
    //  builder: (context) => Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils utils = Utils();
      utils.showSnackBar(e.message);
    }

    // navigatorKey.currentState!.popUntil((route)) => route.isFirst;
  }

  Future guest() async {
    await FirebaseAuth.instance.signInAnonymously();
  }
}
