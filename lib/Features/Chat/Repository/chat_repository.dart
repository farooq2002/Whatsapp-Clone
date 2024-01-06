import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatasppflutterapp/Commons/enums/message_enums.dart';
import 'package:whatasppflutterapp/Models/chat_contact.dart';
import 'package:whatasppflutterapp/Models/message.dart';
import 'package:whatasppflutterapp/Models/user_model.dart';
import 'package:whatasppflutterapp/commons/utils/utils.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
      firestore: FirebaseFirestore.instance,
      firebaseAuth: FirebaseAuth.instance),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  ChatRepository({required this.firestore, required this.firebaseAuth});
  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);

        contacts.add(
          ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }
      return contacts;
    });
  }
  //-------------chat messages-----------------

  Future<Stream<List<Message>>> getChatStream(String recieverUserId) async {
    return firestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("chats")
        .doc(recieverUserId)
        .collection("messages")
        .snapshots()
        .map((event) {});
  }

  void _saveDataToContactSubCollection(
      UserModel senderUserData,
      UserModel recieverUserData,
      String text,
      DateTime timeSent,
      String receiverUserId) async {
    //----------------reviever -----------------------
    var recieverChatContact = ChatContact(
        name: senderUserData.name,
        profilePic: senderUserData.profilePic,
        contactId: senderUserData.uid,
        timeSent: timeSent,
        lastMessage: text);
    firestore
        .collection("users")
        .doc(receiverUserId)
        .collection("chats")
        .doc(firebaseAuth.currentUser!.uid)
        .set(
          recieverChatContact.toMap(),
        );

    //==============sender===================
    var senderChatContact = ChatContact(
        name: recieverUserData.name,
        profilePic: recieverUserData.profilePic,
        contactId: recieverUserData.uid,
        timeSent: timeSent,
        lastMessage: text);
    //======================firestor=============
    firestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("chats")
        .doc(receiverUserId)
        .set(
          senderChatContact.toMap(),
        );
  }

  void _saveMessageToMessageSubCollection({
    required String recieverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required String recieverUsername,
    required MessageEnum messageType,
  }) async {
    //---------------------------------------------
    final message = Message(
      senderId: firebaseAuth.currentUser!.uid,
      recieverid: recieverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
    );
    //======================firestor=============
    await firestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("chats")
        .doc(recieverUserId)
        .collection("messages")
        .doc(messageId)
        .set(
          message.toMap(),
        );
    await firestore
        .collection("users")
        .doc(recieverUserId)
        .collection("chats")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("messages")
        .doc(messageId)
        .set(
          message.toMap(),
        );
  }

  void sendTextMessage(
      {required BuildContext context,
      required String text,
      required String reciverUserId,
      required UserModel senderUser}) async {
    try {
      var timeSent = DateTime.now();
      UserModel reciverUserData;
      var userDataMap =
          await firestore.collection("users").doc(reciverUserId).get();

      reciverUserData = UserModel.fromMap(
        userDataMap.data()!,
      );
      var messageId = const Uuid().v1();
      _saveDataToContactSubCollection(
        senderUser,
        reciverUserData,
        text,
        timeSent,
        reciverUserId,
      );
      _saveMessageToMessageSubCollection(
          recieverUserId: reciverUserId,
          text: text,
          timeSent: timeSent,
          messageType: MessageEnum.text,
          messageId: messageId,
          recieverUsername: reciverUserData.name,
          username: senderUser.name);
    } catch (E) {
      // ignore: use_build_context_synchronously
      showSnackBar(
        context: context,
        content: E.toString(),
      );
    }
  }
}
