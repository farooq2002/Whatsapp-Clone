import 'package:flutter/material.dart';
import 'package:whatasppflutterapp/colors.dart';
import 'package:whatasppflutterapp/commons/Widgets/custom_button.dart';
import 'package:whatasppflutterapp/features/auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void navigateToLogin(BuildContext context) {
      Navigator.pushNamed(context, LoginScreen.routeName);
    }

    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Welcome to WhatsApp",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: size.width / 10),
              SizedBox(
                  child: Image.asset(
                "assets/bg.png",
                height: 300,
                width: 300,
                color: tabColor,
              )),
              SizedBox(height: size.width / 9),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Read our Privacy Policy. Tap "Agree and Continue" to accept the Term of Service.',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                  width: size.width * 0.75,
                  child: CustomButton(
                      title: "AGREE AND CONTINUE",
                      ontap: () {
                        navigateToLogin(context);
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
