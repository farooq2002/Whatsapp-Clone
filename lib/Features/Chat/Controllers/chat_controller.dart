import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatasppflutterapp/Features/Auth/controllers/auth_controller.dart';
import 'package:whatasppflutterapp/Features/Chat/Repository/chat_repository.dart';
import 'package:whatasppflutterapp/Models/chat_contact.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

   Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String reciverUserId,
  ) {
    ref.read(getUserDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
            context: context,
            text: text,
            reciverUserId: reciverUserId,
            senderUser: value!,
          ),
        );
  }
}
