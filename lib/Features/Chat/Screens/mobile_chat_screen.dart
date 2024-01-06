import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatasppflutterapp/Commons/Widgets/loader.dart';
import 'package:whatasppflutterapp/Features/Auth/controllers/auth_controller.dart';
import 'package:whatasppflutterapp/Features/Chat/Widgets/bottom_chat_field.dart';
import 'package:whatasppflutterapp/Features/Chat/Widgets/chat_list.dart';
import 'package:whatasppflutterapp/Models/user_model.dart';
import 'package:whatasppflutterapp/colors.dart';

class MobileChatScreen extends ConsumerWidget {
  final String name;
  final String uid;
  static const String routeName = "/mobile-chat-scree";
  const MobileChatScreen({Key? key, required this.name, required this.uid})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
          stream: ref.watch(authControllerProvider).userDataById(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const Center(
                child: Loader(),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  snapshot.data!.isOnline ? "Online" : "Offline",
                  style: const TextStyle(color: Colors.green, fontSize: 12),
                )
              ],
            );
          },
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          const Expanded(
            child: ChatList(),
          ),
          BottomChatField(reciverUserId: uid),
        ],
      ),
    );
  }
}
