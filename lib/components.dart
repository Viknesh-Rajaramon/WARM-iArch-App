import 'package:flutter/material.dart';

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

class LabelText extends StatelessWidget{
  final String text;
  const LabelText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Color.fromARGB(255, 28, 117, 188), fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

class TextController extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;

  const TextController({
    required this.controller,
    this.obscureText = false,
    this.onToggleVisibility,
    super.key,
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
