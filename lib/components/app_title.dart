import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:warm_app/components/routes.dart";

class AppTitle extends StatelessWidget {
  final String name;
  final String email;
  final String timestamp;

  const AppTitle({
    required this.name,
    required this.email,
    required this.timestamp,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat("MMM d, hh:mm:ss a").format(DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp)));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              email,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: "Last Updated: ",
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: formattedTime,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            )
          ]
        ),
        const _LogoutButton(),
      ]
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _showLogoutDialog(context),
      style: TextButton.styleFrom(
        backgroundColor: Colors.red.shade700,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: const Icon(Icons.logout, color: Colors.white, size: 22),
      label: const Text(
        "Logout",
        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text(
        "Warning",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
      content: const Text(
        "Are you sure you want to exit the app?",
        style: TextStyle(color: Color.fromARGB(255, 28, 117, 188), fontSize: 16, fontWeight: FontWeight.bold),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255, 28, 117, 188))),
              child: const Text(
                "No",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed(AppRoutes.auth);
              },
              child: const Text(
                "Yes",
                style: TextStyle(color: Color.fromARGB(255, 28, 117, 188), fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ]
        )
      ],
    ),
  );
}
