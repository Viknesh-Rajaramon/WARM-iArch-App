import "dart:io";
import "package:flutter/material.dart";

import "package:warm_app/home.dart";
import "package:warm_app/change_password.dart";
import "package:warm_app/db/database.dart";
import "package:warm_app/db/user.dart";
import "package:warm_app/routes.dart";

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  OverlayEntry? errorMessageBox;

  @override
  void initState() {
    super.initState();
    DatabaseService().initializeDB().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> signIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      displayErrorMessage("Please enter your email address and password.");
      return;
    }

    showLoadingDialog();

    final (user, status) = await getUserByEmail(email);
    if (!mounted) {
      return;
    }
    
    Navigator.of(context).pop();

    if (status == HttpStatus.found && user != null) {
      if (isPasswordAndHashEqual(password, user.password, user.salt)) {
        final nextPage = user.isFirstLogin ? SetNewPasswordPage(user: user) : HomePage(userData: user);
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => nextPage),
          );
        }
      } else {
        displayErrorMessage("Incorrect password. Please try again.");
      }
    } else {
      displayErrorMessage("User does not exist.");
    }
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Signing in..."),
          ],
        ),
      ),
    );
  }

  void displayErrorMessage(String error) {
    errorMessageBox?.remove();
    errorMessageBox = _createMessageBox(error);
    Overlay.of(context).insert(errorMessageBox!);

    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        errorMessageBox?.remove();
        errorMessageBox = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Login",
              style: TextStyle(color: Color.fromARGB(255, 28, 117, 188), fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Please login to continue using the app.",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ]
        ),
        toolbarHeight: 100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _LabelText("EMAIL ADDRESS"),
            const SizedBox(height: 10),
            _TextField(controller: emailController),
            const SizedBox(height: 30),
            const _LabelText("PASSWORD"),
            const SizedBox(height: 10),
            _TextField(controller: passwordController, obscureText: obscurePassword, onToggleVisibility: () => setState(() => obscurePassword = !obscurePassword)),
            const SizedBox(height: 40),
            _LoginButton(onPressed: signIn),
            const SizedBox(height: 5),
            const _ForgotPasswordButton(),
          ],
        ),
      ),
    );
  }
}

class _LabelText extends StatelessWidget{
  final String text;
  const _LabelText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Color.fromARGB(255, 28, 117, 188), fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;

  const _TextField({
    required this.controller,
    this.obscureText = false,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
          if (onToggleVisibility != null)
            IconButton(
              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
              onPressed: onToggleVisibility,
            ),
        ],
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _LoginButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 125,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 28, 117, 188),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
          ),
          icon: const Icon(Icons.login, color: Colors.white, size: 24),
          label: const Text(
            "Login",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  const _ForgotPasswordButton();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.forgotPassword),
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Color.fromARGB(255, 28, 117, 188), fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

OverlayEntry _createMessageBox(String error) {
  return OverlayEntry(
    builder: (context) => Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.red.shade600,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            error,
            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),              
        ),
      ),
    ),
  );
}
