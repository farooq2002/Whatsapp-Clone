import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatasppflutterapp/commons/utils/utils.dart';
import 'package:whatasppflutterapp/features/Auth/controllers/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final nameController = TextEditingController();
  File? pic;

  void storeUserData() async {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .savedUserDataToFirebase(context, name, pic);
    }
  }

  void selecImage() async {
    pic = await pickImageFromGallery(context);
    debugPrint("image path is : $pic");
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  pic == null
                      ? const CircleAvatar(
                          radius: 50,
                          child: Icon(
                            Icons.person_2_outlined,
                            size: 50,
                          ),
                        )
                      : CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(pic!),
                          foregroundImage: FileImage(pic!),
                        ),
                  Positioned(
                    left: 70,
                    bottom: -4,
                    child: InkWell(
                        onTap: selecImage,
                        child: const Icon(Icons.add_a_photo)),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.85,
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(hintText: "Enter your name"),
                  ),
                ),
                IconButton(
                    onPressed: storeUserData, icon: const Icon(Icons.done))
              ],
            )
          ],
        ),
      ),
    );
  }
}
