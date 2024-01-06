// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatasppflutterapp/Commons/utils/utils.dart';
import 'package:whatasppflutterapp/Models/user_model.dart';
import 'package:whatasppflutterapp/Features/Chat/Screens/mobile_chat_screen.dart';

//-------------SELECT CONTACT PROVIDER----------------
final selectContactRepositoryProvider = Provider(
  (ref) => SelectContactRepository(firestore: FirebaseFirestore.instance),
);

//---------------SelectContactRepository---------------
class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({required this.firestore});
//-------------------GET ALL USER CONTACT NUMBERS WITH NAMES-----------------

  Future<List<Contact>> getContacts() async {
    List<Contact> contactsList = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contactsList = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (E) {
      debugPrint(E.toString());
    }
    return contactsList;
  }

//-----------------SELECT CONTACT FOR CHAT-----------------------------------

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedPhoneNum = selectedContact.phones[0].number.replaceAll(
          ' ',
          '',
        );
        if (selectedPhoneNum == userData.phoneNumber) {
          isFound = true;
          Navigator.pushNamed(
            context,
            MobileChatScreen.routeName,
            arguments: {
              'name': userData.name,
              'uid': userData.uid,
            },
          );
        }
      }

      if (!isFound) {
        showSnackBar(
          context: context,
          content: 'This number does not exist on this app.',
        );
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
