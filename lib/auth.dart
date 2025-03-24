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
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  OverlayEntry? errorMessageBox;
  late Future<void> db;

  @override
  void initState() {
    super.initState();
    db = DatabaseService().initializeDB();
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
    errorMessageBox = createMessageBox(error);

    Overlay.of(context).insert(errorMessageBox!);

    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        errorMessageBox?.remove();
        errorMessageBox = null;
      }
    });
  }

  OverlayEntry createMessageBox(String error) {
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: db,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return loginScreen();
      },
    );
  }

  Widget loginScreen() {
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
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            builtLabel("EMAIL ADDRESS"),
            const SizedBox(height: 10),
            buildTextField(emailController),
            const SizedBox(height: 30),
            builtLabel("PASSWORD"),
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

  Widget builtLabel(String text) {
    return Text(
      text,
      style: const TextStyle(color: Color.fromARGB(255, 28, 117, 188), fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget buildTextField(TextEditingController controller, {bool obscureText = false, bool displayEyeIcon = false}) {
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
          if (displayEyeIcon) ...[
            IconButton(
              icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => obscurePassword = !obscurePassword),
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
        child: ElevatedButton.icon(
          onPressed: signIn,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 28, 117, 188),
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
        onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.forgotPassword),
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Color.fromARGB(255, 28, 117, 188), fontSize: 18, fontWeight: FontWeight.bold)
        ),
      ),
    );
  }
}
