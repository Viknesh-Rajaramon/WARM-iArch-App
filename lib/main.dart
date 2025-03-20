import "package:flutter/material.dart";

import "package:warm_app/auth.dart";
import "package:warm_app/faq_page.dart";
import "package:warm_app/forgot_password.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const IArchApp());
}

class IArchApp extends StatelessWidget {
  const IArchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/auth",
      routes: {
        "/auth": (_) => const AuthPage(),
        "/faq": (_) => const FAQPage(),
        "/forgot_password": (_) => const ForgotPasswordPage(),
      },
    );
  }
}
