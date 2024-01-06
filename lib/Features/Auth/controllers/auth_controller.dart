import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatasppflutterapp/Models/user_model.dart';
import 'package:whatasppflutterapp/features/Auth/repository/auth_repository.dart';

//------------RIVERPOD PROVIDER FOR AUTH CONTROLLER---------------
final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(ref: ref, authRepository: authRepository);
});

//---------------FUTURE PROVIDER FOR GETUSERDATA------------------

final getUserDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

//--------------AUTH CONTROLLER-----------------------------------
class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({required this.authRepository, required this.ref});

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUser();
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyphoneOtp(BuildContext context, String verificaionID, String oTP) {
    authRepository.verifyOTP(
        context: context, verificationId: verificaionID, userOTP: oTP);
  }

  void savedUserDataToFirebase(
    BuildContext context,
    String name,
    File? profilePic,
  ) {
    authRepository.saveUserDataToFirebase(
        context: context, ref: ref, userName: name, profilePic: profilePic);
  }
   Stream<UserModel> userDataById(String userId) {
    return authRepository.userData(userId);
  }

  // void setUserState(bool isOnline) {
  //   authRepository.setUserState(isOnline);
  // }
}
