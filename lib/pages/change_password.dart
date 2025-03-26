import "dart:io";
import "package:flutter/material.dart";

import "package:warm_app/db/user.dart";
import "package:warm_app/components/routes.dart";
import "package:warm_app/components/components.dart";

class SetNewPasswordPage extends StatefulWidget {
  final User user;

  const SetNewPasswordPage({
    required this.user,
    super.key
  });

  @override
  SetNewPasswordPageState createState() => SetNewPasswordPageState();
}

class SetNewPasswordPageState extends State<SetNewPasswordPage> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController = TextEditingController();
  bool obscurePassword = true;
  OverlayEntry? messageBox;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> setNewPassword() async {
    final newPassword = newPasswordController.text.trim();
    final confirmNewPassword = confirmNewPasswordController.text.trim();

    if (newPassword.length < 6) {
      displayMessage("Password must be at least 6 characters long.", Colors.red.shade600);
      return;
    } else if (newPassword != confirmNewPassword) {
      displayMessage("The passwords do not match.", Colors.red.shade600);
      return;
    }

    final status = await updateUserPassword(widget.user.uuid, newPassword);
    if (status == HttpStatus.accepted) {
      displayMessage("Password updated successfully.", Colors.lightGreen.shade600);

      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.auth);
      }
    } else {
      displayMessage("Failed to update password. Please try again.", Colors.red.shade600);
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
      appBar: const _SetNewPasswordAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelText("NEW PASSWORD"),
            const SizedBox(height: 10),
            TextController(controller: newPasswordController),
            const SizedBox(height: 30),
            LabelText("CONFIRM NEW PASSWORD"),
            const SizedBox(height: 10),
            TextController(controller: confirmNewPasswordController, obscureText: obscurePassword, onToggleVisibility: () => setState(() => obscurePassword = !obscurePassword)),
            const SizedBox(height: 40),
            UpdateButton(onPressed: setNewPassword),
          ],
        ),
      ),
    );
  }
}

class _SetNewPasswordAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _SetNewPasswordAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        "Set up New Password",
        style: TextStyle(color: Color.fromARGB(255, 28, 117, 188), fontSize: 30, fontWeight: FontWeight.bold),
      ),
      toolbarHeight: 100,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class UpdateButton extends StatelessWidget {
  final VoidCallback onPressed;

  const UpdateButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 125,
        height: 50,
        child: TextButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 28, 117, 188),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          icon: const Icon(Icons.login, color: Colors.white, size: 24),
          label: const Text(
            "Update",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
