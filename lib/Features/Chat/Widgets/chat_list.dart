import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatasppflutterapp/Features/Chat/Widgets/my_message_card.dart';
import 'package:whatasppflutterapp/Widgets/sender_message_card.dart';
import 'package:whatasppflutterapp/info.dart';

class ChatList extends ConsumerWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
        stream: ref,
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              if (messages[index]['isMe'] == true) {
                return MyMessageCard(
                  message: messages[index]['text'].toString(),
                  date: messages[index]['time'].toString(),
                );
              }
              return SenderMessageCard(
                message: messages[index]['text'].toString(),
                date: messages[index]['time'].toString(),
              );
            },
          );
        });
  }
}
