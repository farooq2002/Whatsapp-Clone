import 'package:flutter/material.dart';
import 'package:whatasppflutterapp/colors.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback ontap;
  const CustomButton({super.key, required this.title, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: tabColor),
      onPressed: ontap,
      child: Text(
        title,
        style: const TextStyle(color: blackColor),
      ),
    );
  }
}
