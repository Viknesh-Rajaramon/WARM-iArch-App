import "dart:io";
import "package:flutter/material.dart";

import "package:warm_app/db/user.dart";
import "package:warm_app/change_password.dart";
import "package:warm_app/components.dart";

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  OverlayEntry? messageBox;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> setNewPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      displayMessage("Please enter your email address.", Colors.red.shade600);
      return;
    }
    
    final (user, status) = await getUserByEmail(email);
    if (!mounted) {
      return;
    }

    switch (status) {
      case HttpStatus.found:
        if (user != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => SetNewPasswordPage(user: user)),
          );
        } else {
          displayMessage("User not found.", Colors.red.shade600);
        }
        break;
      case HttpStatus.notFound:
        displayMessage("User not found.", Colors.red.shade600);
        break;
      default:
        displayMessage("Could not fetch user. Please try again.", Colors.red.shade600);
        break;
    }
  }

  void displayMessage(String message, Color backgroundColor) {
    messageBox?.remove();
    messageBox = createMessageBox(message, backgroundColor);

    Overlay.of(context).insert(messageBox!);

    Future.delayed(const Duration(seconds: 3), () {
      if (messageBox != null) {
        messageBox?.remove();
        messageBox = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _ForgotPasswordAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LabelText("Enter your Email Address"),
            const SizedBox(height: 10),
            TextController(controller: emailController),
            const SizedBox(height: 40),
            _ContinueButton(onPressed: setNewPassword),
          ],
        ),
      ),
    );
  }
}

class _ForgotPasswordAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ForgotPasswordAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        "Forgot Password",
        style: TextStyle(color: Color.fromARGB(255, 28, 117, 188), fontSize: 30, fontWeight: FontWeight.bold),
      ),
      toolbarHeight: 100,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _ContinueButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _ContinueButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 125,
        height: 50,
        child: TextButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 28, 117, 188),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
          ),
          child: const Text(
            "Continue",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
