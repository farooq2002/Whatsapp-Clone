import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatasppflutterapp/Commons/Widgets/loader.dart';
import 'package:whatasppflutterapp/Features/Chat/Controllers/chat_controller.dart';
import 'package:whatasppflutterapp/Features/Chat/Screens/mobile_chat_screen.dart';
import 'package:whatasppflutterapp/Models/chat_contact.dart';
import 'package:whatasppflutterapp/info.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: StreamBuilder<List<ChatContact>>(
          stream: ref.watch(chatControllerProvider).chatContacts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var chatContatData = snapshot.data![index];
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              MobileChatScreen.routeName,
                              arguments: {
                                'name': chatContatData.name,
                                'uid': chatContatData.contactId
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 1.0),
                          child: ListTile(
                            title: Text(
                              chatContatData.name,
                              style: const TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 1.0),
                              child: Text(
                                chatContatData.lastMessage,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                chatContatData.profilePic,
                              ),
                              radius: 25,
                            ),
                            trailing: Text(
                              DateFormat.Hm().format(chatContatData.timeSent),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // const Divider(color: dividerColor, indent: 85, height: 1),
                    ],
                  );
                },
              );
            }
          }),
    );
  }
}
