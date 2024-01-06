import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatasppflutterapp/colors.dart';
import 'package:whatasppflutterapp/commons/Widgets/custom_button.dart';
import 'package:whatasppflutterapp/commons/utils/utils.dart';
import 'package:whatasppflutterapp/features/Auth/controllers/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = "/login-screen";
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();

  Country? country;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountryCode() {
    showCountryPicker(
      context: context,
      onSelect: (Country countrycode) {
        setState(() {
          country = countrycode;
        });
      },
    );
  }

  void sendPhoneNumber() {
    String phoneNum = phoneController.text.trim();

    if (country != null && phoneNum.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, "+${country!.phoneCode}$phoneNum");
      showSnackBar(content: "Code has been sent!", context: context);
    } else {
      showSnackBar(content: "Fill out all the feilds!", context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Enter Your Phone Number"),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("WhatsApp will need to verify your phone number"),
            const SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: () {
                  pickCountryCode();
                },
                child: const Text(
                  "Pick a Country",
                  style: TextStyle(color: Colors.green),
                )),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (country != null) Text("+${country!.phoneCode}"),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: size.width * 0.7,
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    decoration: const InputDecoration(hintText: "phone number"),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.5,
            ),
            SizedBox(
              width: 140,
              child: CustomButton(title: "NEXT", ontap: sendPhoneNumber),
            ),
          ],
        ),
      ),
    );
  }
}

