import 'package:flutter/material.dart';

import 'package:warm_app/auth.dart';
import 'package:warm_app/faq_page.dart';
import 'package:warm_app/forgot_password.dart';

class AppRoutes {
  static const String auth = "/auth";
  static const String faq = "/faq";
  static const String forgotPassword = "/forgot_password";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routes = <String, WidgetBuilder> {
      auth: (context) => const AuthPage(),
      faq: (context) => const FAQPage(),
      forgotPassword: (context) => const ForgotPasswordPage(),
    };

    WidgetBuilder? builder = routes[settings.name];
    return MaterialPageRoute(
      builder: (context) => builder != null ? builder(context) : const AuthPage(),
    );
  }
}
