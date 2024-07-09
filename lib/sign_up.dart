import 'package:flutter/material.dart';
import 'app_localizations.dart';

class SignUp extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('signUp') ?? ''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate('name')),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate('email') ?? ''),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate('password') ?? ''),
              obscureText: true,
            ),
            TextField(
              controller: dobController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate('dob')),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to the home screen
              },
              child: Text(AppLocalizations.of(context)!.translate('sign_up_button')?? ''),
            ),
          ],
        ),
      ),
    );
  }
}
