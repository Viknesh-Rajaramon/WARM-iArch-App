import "dart:io";
import "package:flutter/material.dart";

import "package:warm_app/home.dart";
import "package:warm_app/change_password.dart";
import "package:warm_app/db/database.dart";
import "package:warm_app/db/user.dart";
import "package:warm_app/routes.dart";
import "package:warm_app/components.dart";

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
    errorMessageBox = createMessageBox(error, Colors.red.shade600);
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
      appBar: const _AuthPageAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LabelText("EMAIL ADDRESS"),
            const SizedBox(height: 10),
            TextController(controller: emailController),
            const SizedBox(height: 30),
            const LabelText("PASSWORD"),
            const SizedBox(height: 10),
            TextController(controller: passwordController, obscureText: obscurePassword, onToggleVisibility: () => setState(() => obscurePassword = !obscurePassword)),
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

class _AuthPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AuthPageAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Login",
            style: TextStyle(color: Color.fromARGB(255, 28, 117, 188), fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "Please login to continue using the app.",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ],
      ),
      toolbarHeight: 100,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
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
