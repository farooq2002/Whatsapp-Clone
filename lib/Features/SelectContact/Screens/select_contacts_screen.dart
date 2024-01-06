import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatasppflutterapp/Commons/Widgets/error.dart';
import 'package:whatasppflutterapp/Commons/Widgets/loader.dart';
import 'package:whatasppflutterapp/Features/SelectContact/Controllers/select_contacts_controller.dart';

class SelectContactScreen extends ConsumerWidget {
  static const String routeName = "/select-contacts-screen";
  const SelectContactScreen({super.key});

  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Contacts"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: ref.watch(getContactsProvider).when(
          data: (contactsList) => ListView.builder(
              itemCount: contactsList.length,
              itemBuilder: (context, index) {
                final userContacts = contactsList[index];
                return InkWell(
                  onTap: () => selectContact(ref, userContacts, context),
                  child: Column(
                    children: [
                      ListTile(
                        leading: userContacts.photo == null
                            ? const CircleAvatar(
                                child: Icon(Icons.person),
                              )
                            : CircleAvatar(
                                backgroundImage:
                                    MemoryImage(userContacts.photo!),
                              ),
                        title: Text(userContacts.displayName),
                        subtitle: Text(userContacts.phones.first.number),
                      ),
                      const Divider()
                    ],
                  ),
                );
              }),
          error: (error, trace) {
            return ErrorScreen(errorText: error.toString());
          },
          loading: () {
            return const Loader();
          }),
    );
  }
}
