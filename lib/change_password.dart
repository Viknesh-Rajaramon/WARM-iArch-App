import "dart:io";
import "package:flutter/material.dart";

import "package:warm_app/db/user.dart";
import "package:warm_app/routes.dart";

class SetNewPasswordPage extends StatefulWidget {
  final User user;

  const SetNewPasswordPage({
    required this.user,
    super.key
  });

  @override
  _SetNewPasswordPageState createState() => _SetNewPasswordPageState();
}

class _SetNewPasswordPageState extends State<SetNewPasswordPage> {
  late User user;
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController = TextEditingController();
  bool obscurePassword = true;
  OverlayEntry? messageBox;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  Future<void> setNewPassword() async {
    final newPassword = newPasswordController.text.trim();
    final confirmNewPassword = confirmNewPasswordController.text.trim();

    if (newPassword.isEmpty || newPassword.length < 6) {
      displayErrorMessage("Password must be at least 6 characters long.");
      return;
    } else if (confirmNewPassword.isEmpty) {
      displayErrorMessage("Please confirm your new password.");
      return;
    } else if (newPassword != confirmNewPassword) {
      displayErrorMessage("The passwords do not match.");
      return;
    }

    final status = await updateUserPassword(user.uuid, newPassword);
    if (status == HttpStatus.accepted) {
      displaySuccessMessage("Password updated successfully.");

      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.auth);
      }
    } else {
      displayErrorMessage("Failed to update password. Please try again.");
    }    
  }

  void displayErrorMessage(String error) {
    displayMessage(error, Colors.red.shade600);
  }

  void displaySuccessMessage(String message) {
    displayMessage(message, Colors.lightGreen.shade600);
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

  OverlayEntry createMessageBox(String message, Color? backgroundColor) {
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
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
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
        title: const Text(
          "Set up New Password",
          style: TextStyle(color: Color.fromARGB(255, 28, 117, 188), fontSize: 30, fontWeight: FontWeight.bold),
        ),
        toolbarHeight: 100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            builtText("NEW PASSWORD"),
            const SizedBox(height: 10),
            buildPasswordField(newPasswordController),
            const SizedBox(height: 30),
            builtText("CONFIRM NEW PASSWORD"),
            const SizedBox(height: 10),
            buildPasswordField(confirmNewPasswordController, obscureText: obscurePassword, displayEyeIcon: true),
            const SizedBox(height: 40),
            updateButton(),
          ],
        ),
      ),
    );
  }

  Widget builtText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Color.fromARGB(255, 28, 117, 188), fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget buildPasswordField(TextEditingController controller, {bool obscureText = false, bool displayEyeIcon = false}) {
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
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
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

  Widget updateButton() {
    return Center(
      child: SizedBox(
        width: 125,
        height: 50,
        child: TextButton.icon(
          onPressed: setNewPassword,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 28, 117, 188),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          icon: const Icon(Icons.login, color: Colors.white, size: 24),
          label: const Text(
            "Update",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
          ),
        ),
      ),
    );
  }
}
