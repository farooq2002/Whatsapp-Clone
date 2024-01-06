import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatasppflutterapp/colors.dart';
import 'package:whatasppflutterapp/features/Auth/controllers/auth_controller.dart';

class OTPScreen extends ConsumerWidget {
  static const routeName = "/otp-screen";
  final String verificationId;
  const OTPScreen({super.key, required this.verificationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //---------------verfyning otp-----------------------
    void verifyOtp(BuildContext context, String otp, WidgetRef ref) {
      ref
          .read(authControllerProvider)
          .verifyphoneOtp(context, verificationId, otp);
    }

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Code"),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text("We have sent an SMS for verification."),
            SizedBox(
              width: size.width * 0.5,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "- - - - -",
                  hintStyle: TextStyle(fontSize: 30),
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  if (val.length == 6) {
                    verifyOtp(context, val.trim(), ref);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
