import "dart:io";
import "package:flutter/material.dart";

import "package:warm_app/db/user.dart";
import "package:warm_app/change_password.dart";

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  OverlayEntry? messageBox;

  @override
  void initState() {
    super.initState();
  }

  Future<void> setNewPassword() async {
    final email = emailController.text.trim();

    if (email == "") {
      displayErrorMessage("Please enter your email address.");
      return;
    }

    displayLoadingMessage("Checking email...");
    
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
          displayErrorMessage("User not found.");
        }
        break;
      case HttpStatus.notFound:
        displayErrorMessage("User not found.");
        break;
      default:
        displayErrorMessage("Could not fetch user. Please try again.");
        break;
    }
  }

  void displayErrorMessage(String error) {
    displayMessage(error, Colors.red.shade600);
  }

  void displayLoadingMessage(String message) {
    displayMessage(message, Colors.blue.shade600);
  }

  void displayMessage(String message, Color backgroundColor) {
    messageBox?.remove();
    messageBox = createMessageBox(message, backgroundColor);

    Overlay.of(context).insert(messageBox!);

    Future.delayed(Duration(seconds: 3), () {
      if (messageBox != null) {
        messageBox?.remove();
        messageBox = null;
      }
      
    });
  }

  OverlayEntry createMessageBox(String error, Color? backgroundColor) {
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
              color: backgroundColor,
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
        title: Text(
          "Forgot Password",
          style: TextStyle(color: Color.fromARGB(255, 28, 117, 188), fontSize: 30, fontWeight: FontWeight.bold),
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
              "Enter your Email Address",
              style: TextStyle(color: Color.fromARGB(255, 28, 117, 188), fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            buildTextField(emailController),
            const SizedBox(height: 40),
            continueButton(),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Enter your email",
        ),
        autofocus: true,
      ),
    );
  }

  Widget continueButton() {
    return Center(
      child: SizedBox(
        width: 125,
        height: 50,
        child: TextButton.icon(
          onPressed: setNewPassword,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 28, 117, 188),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          label: const Text(
            "Continue",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
          ),
        ),
      ),
    );
  }
}
