import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authentication_service.dart';
import 'app_localizations.dart';

class SignIn extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('signIn') ?? '') ,

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate('email') ??''),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate('password') ?? ''),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await context.read<AuthenticationService>().signIn(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  Navigator.pop(context); // Navigate back to the home screen
                } catch (e) {
                  // Handle sign in error
                }
              },
              child: Text(AppLocalizations.of(context)!.translate('sign_in_button') ?? 'sign_in_button'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await context.read<AuthenticationService>().signInWithGoogle();
                  Navigator.pop(context); // Navigate back to the home screen
                } catch (e) {
                  // Handle Google sign in error
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error signing in with Google: $e')));
                }
              },
              child: Text(AppLocalizations.of(context)!.translate('sign_in_google_button')?? ''),
            ),
          ],
        ),
      ),
    );
  }
}
