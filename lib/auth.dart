import "dart:io";
import "package:flutter/material.dart";

import "package:warm_app/home.dart";
import "package:warm_app/db/user.dart";

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signIn() async {
    final result = await getUserByEmail(emailController.text.trim());
    if (result.$2 == HttpStatus.found) {
      final User user = result.$1 as User;
      if (isPasswordAndHashEqual(passwordController.text.trim(), user.password, user.salt)) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage(projectId: user.projectId)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Incorrect password. Please try again.")),
      );
      }
    } else if (result.$2 == HttpStatus.notFound) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User does not exist.")),
      );
    } else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Email"),
              controller: emailController,
            ),
            TextField(
              decoration: InputDecoration(labelText: "Password"),
              controller: passwordController,
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: signIn,
              child: Text("Login"),
            )
          ],
        ),
      ),
    );
  }
}
