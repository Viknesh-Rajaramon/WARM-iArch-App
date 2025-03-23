import 'package:flutter/material.dart';

import 'package:warm_app/auth.dart';
import 'package:warm_app/faq_page.dart';
import 'package:warm_app/forgot_password.dart';

class AppRoutes {
  static const String auth = "/auth";
  static const String faq = "/faq";
  static const String forgotPassword = "/forgot_password";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case auth:
        return MaterialPageRoute(builder: (_) => const AuthPage());
      case faq:
        return MaterialPageRoute(builder: (_) => const FAQPage());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
      default:
        return MaterialPageRoute(builder: (_) => const AuthPage());
    }
  }
}
