import "dart:io";
import "package:flutter/material.dart";

import "package:warm_app/home.dart";
import "package:warm_app/change_password.dart";
import "package:warm_app/db/database.dart";
import "package:warm_app/db/user.dart";

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  OverlayEntry? errorMessageBox;

  @override
  void initState() {
    super.initState();
    setUpDB();
  }

  Future<void> setUpDB() async {
    await Future.delayed(Duration(milliseconds: 100));
    await DatabaseService().initializeDB();
  }

  Future<void> signIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email == "" && password == "") {
      displayErrorMessage("Please enter your email address and password.");
      return;
    } else if (email == "") {
      displayErrorMessage("Please enter your email address.");
      return;
    } else if (password == "") {
      displayErrorMessage("Please enter your password.");
      return;
    } else {}

    final (user, status) = await getUserByEmail(email);
    switch (status) {
      case HttpStatus.found:
        if (user != null && isPasswordAndHashEqual(passwordController.text.trim(), user.password, user.salt)) {
          if (user.isFirstLogin) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SetNewPasswordPage(user: user)),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage(userData: user)),
            );
          }
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

  Future<void> forgotPassword() async {
    Navigator.of(context).pushReplacementNamed("/forgot_password");
  }

  void displayErrorMessage(String error) {
    errorMessageBox?.remove();
    errorMessageBox = createErrorMessageBox(error);

    Overlay.of(context).insert(errorMessageBox!);

    Future.delayed(Duration(seconds: 3), () {
      errorMessageBox?.remove();
      errorMessageBox = null;
    });
  }

  OverlayEntry createErrorMessageBox(String error) {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.red.shade600,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              error,
              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
            ),              
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Login",
              style: TextStyle(color: Color.fromARGB(255, 28, 117, 188), fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Please login to continue using the app.",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ]
        ),
        toolbarHeight: 100,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "EMAIL ADDRESS",
              style: TextStyle(color: Color.fromARGB(255, 28, 117, 188), fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            buildTextField(emailController),
            const SizedBox(height: 30),
            Text(
              "PASSWORD",
              style: TextStyle(color: Color.fromARGB(255, 28, 117, 188), fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            buildTextField(passwordController, obscureText: obscurePassword, displayEyeIcon: true),
            const SizedBox(height: 40),
            loginButton(),
            const SizedBox(height: 5),
            forgotPasswordButton(),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, {bool obscureText = false, bool displayEyeIcon = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          if (displayEyeIcon) ...[
            IconButton(
              icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
            ),
          ]
        ]
      )
    );
  }

  Widget loginButton() {
    return Center(
      child: SizedBox(
        width: 125,
        height: 50,
        child: TextButton.icon(
          onPressed: signIn,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 28, 117, 188),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          icon: const Icon(Icons.login, color: Colors.white, size: 24),
          label: const Text(
            "Login",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
          ),
        ),
      ),
    );
  }

  Widget forgotPasswordButton() {
    return Center(
      child: TextButton(
        onPressed: forgotPassword,
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Color.fromARGB(255, 28, 117, 188), fontSize: 18, fontWeight: FontWeight.bold)
        ),
      ),
    );
  }
}
