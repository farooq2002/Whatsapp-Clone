import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatasppflutterapp/Features/SelectContact/Repository/select_contact_repository.dart';

//-----------------getContactsProvider--------------------------------

final getContactsProvider = FutureProvider((ref) {
  final selectContactsRepository = ref.watch(selectContactRepositoryProvider);
  return selectContactsRepository.getContacts();
});

//------------------selectContactControllerProvider-----------------------

final selectContactControllerProvider = Provider((ref) {
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);
  return SelectContactController(
      ref: ref, selectContactRepository: selectContactRepository);
});


//--------------------------------------------------------------------------
class SelectContactController {
  final ProviderRef ref;
  final SelectContactRepository selectContactRepository;

  SelectContactController(
      {required this.ref, required this.selectContactRepository});

  void selectContact(Contact selectedContact, BuildContext context) {
    selectContactRepository.selectContact(selectedContact, context);
  }
}
