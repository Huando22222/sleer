import 'package:contacts_service/contacts_service.dart';

abstract class ContactState {
  // List<Contact> contacts;

  // ContactState({
  //   required this.contacts,
  // });
}

class ContactInitial extends ContactState {
  // ContactInitialState() : super(contacts: []);
}

class ContactFetchingLoadingState extends ContactState {}

class ContactFetchingErrorState extends ContactState {}

class ContactFetchingSuccessState extends ContactState {
  List<Contact> contacts;
  ContactFetchingSuccessState({
    required this.contacts,
  });
}
