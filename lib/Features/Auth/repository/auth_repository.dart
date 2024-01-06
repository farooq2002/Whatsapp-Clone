import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatasppflutterapp/Models/user_model.dart';
import 'package:whatasppflutterapp/commons/repository/common_firebase_storage.dart';
import 'package:whatasppflutterapp/commons/utils/utils.dart';
import 'package:whatasppflutterapp/features/Auth/screens/otp_screen.dart';
import 'package:whatasppflutterapp/features/Auth/screens/user_info_screen.dart';
import 'package:whatasppflutterapp/screens/mobile_layout_screen.dart';

//--------------------AUTH REPO PROVIDER---------------------------------------
final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth, required this.firestore});

  Future<UserModel?> getCurrentUser() async {
    var userData =
        await firestore.collection("users").doc(auth.currentUser?.uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  //------------SIGINING USER WITH PHONE NUMBER FIREBASE------------------------

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          throw Exception(e.message);
        },
        codeSent: ((String verificationId, int? resendToken) async {
          Navigator.pushNamed(
            context,
            OTPScreen.routeName,
            arguments: verificationId,
          );
        }),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context: context, content: e.message!);
    }
  }

//------------VERIFYING USER WITH PHONE NUMBER FIREBASE------------------------
  void verifyOTP(
      {required BuildContext context,
      required String verificationId,
      required String userOTP}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(
          context, UserInformationScreen.routeName, (route) => false);
    } catch (E) {
      // ignore: use_build_context_synchronously
      showSnackBar(context: context, content: E.toString());
    }
  }
  //------------SIGINING USER WITH PHONE NUMBER FIREBASE------------------------

  void saveUserDataToFirebase(
      {required BuildContext context,
      required ProviderRef ref,
      required String userName,
      required File? profilePic}) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          "https://www.google.com/imgres?imgurl=https%3A%2F%2Fstatic.vecteezy.com%2Fsystem%2Fresources%2Fpreviews%2F005%2F544%2F718%2Fnon_2x%2Fprofile-icon-design-free-vector.jpg&tbnid=_5mhIFxchtSFMM&vet=12ahUKEwjn-omIyeaCAxWAU6QEHRfGC1cQMygAegQIARBu..i&imgrefurl=https%3A%2F%2Fwww.vecteezy.com%2Ffree-vector%2Fprofile-icon&docid=RBpRIqik_jZCqM&w=980&h=980&q=profile&ved=2ahUKEwjn-omIyeaCAxWAU6QEHRfGC1cQMygAegQIARBu";

      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepository)
            .saveFileToFirebase("profilepic/$uid", profilePic);
      }
      var user = UserModel(
          name: userName,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber.toString(),
          groupId: []);

      firestore.collection("users").doc(uid).set(user.toMap());
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MobileLayoutScreen()),
          (route) => false);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  //---------------GET USER FROM FIREBASE FOR ONLINE OR OFFLINE STATUS---------

 Stream<UserModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }
}
