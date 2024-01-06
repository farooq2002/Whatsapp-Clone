import 'package:flutter/material.dart';
import 'package:whatasppflutterapp/Features/SelectContact/Screens/select_contacts_screen.dart';
import 'package:whatasppflutterapp/Features/Chat/Screens/mobile_chat_screen.dart';
import 'package:whatasppflutterapp/commons/Widgets/error.dart';
import 'package:whatasppflutterapp/features/auth/screens/login_screen.dart';
import 'package:whatasppflutterapp/features/auth/screens/otp_screen.dart';
import 'package:whatasppflutterapp/features/auth/screens/user_info_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(verificationId: verificationId),
      );
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInformationScreen(),
      );
    case SelectContactScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactScreen(),
      );
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(name: name, uid: uid),
      );
    default:
      return MaterialPageRoute(
          builder: (context) => const Scaffold(
              body: ErrorScreen(errorText: "This page doesn't exist!")));
  }
}
