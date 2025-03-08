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
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email == "" || password == "") {
      displayErrorMessage("Please fill in all fields.");
      return;
    }

    final (user, status) = await getUserByEmail(email);
    switch (status) {
      case HttpStatus.found:
        if (user != null && isPasswordAndHashEqual(passwordController.text.trim(), user.password, user.salt)) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage(projectId: user.projectId)),
          );
        } else {
          displayErrorMessage("Incorrect password. Please try again.");
        }
        break;
      case HttpStatus.notFound:
        displayErrorMessage("User does not exist.");
        break;
      default:
        displayErrorMessage("Login failed. Please try again.");
        break;
    }
  }

  void displayErrorMessage(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error)),
    );
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
            buildTextField(emailController, "Email"),
            buildTextField(passwordController, "Password", obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: signIn,
              child: Text("Login"),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      obscureText: obscureText,
    );
  }
}
