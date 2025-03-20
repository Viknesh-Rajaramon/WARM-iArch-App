import "dart:io";
import "package:flutter/material.dart";

import "package:warm_app/db/user.dart";

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

    if (newPassword == "") {
      displayErrorMessage("Please enter your new password.");
      return;
    } else if (confirmNewPassword == "") {
      displayErrorMessage("Please enter your new password again for confirmation.");
      return;
    } else if (newPassword != confirmNewPassword) {
      displayErrorMessage("The password does not match.");
      return;
    } else {}

    final status = await updateUserPassword(user.uuid, newPassword);
    switch (status) {
      case HttpStatus.accepted:
        displaySuccessMessage("Password updated successfully.");
        break;
      default:
        displayErrorMessage("Failed to update password.");
        break;
    }

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/auth');
    }
  }

  void displayErrorMessage(String error) {
    messageBox?.remove();
    messageBox = createMessageBox(error, Colors.red.shade600);

    Overlay.of(context).insert(messageBox!);

    Future.delayed(Duration(seconds: 3), () {
      messageBox?.remove();
      messageBox = null;
    });
  }

  void displaySuccessMessage(String error) {
    messageBox?.remove();
    messageBox = createMessageBox(error, Colors.lightGreen.shade600);

    Overlay.of(context).insert(messageBox!);

    Future.delayed(Duration(seconds: 3), () {
      messageBox?.remove();
      messageBox = null;
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
          "Set up New Password",
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
              "NEW PASSWORD",
              style: TextStyle(color: Color.fromARGB(255, 28, 117, 188), fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            buildTextField(newPasswordController),
            const SizedBox(height: 30),
            Text(
              "CONFIRM NEW PASSWORD",
              style: TextStyle(color: Color.fromARGB(255, 28, 117, 188), fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            buildTextField(confirmNewPasswordController, obscureText: obscurePassword, displayEyeIcon: true),
            const SizedBox(height: 40),
            updateButton(),
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

  Widget updateButton() {
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
