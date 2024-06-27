import 'dart:async';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleer/blocs/contact_bloc/contact_event.dart';
import 'package:sleer/blocs/contact_bloc/contact_state.dart';
import 'package:sleer/services/contact_service.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc() : super(ContactInitial()) {
    on<ContactInitialEvent>(getContactEvent);
  }

  FutureOr<void> getContactEvent(
    ContactInitialEvent event,
    Emitter<ContactState> emit,
  ) async {
    emit(ContactFetchingLoadingState());
    try {
      List<Contact> contacts = await ContactService.fetchContacts();
      emit(ContactFetchingSuccessState(contacts: contacts));
    } catch (e) {
      emit(ContactFetchingErrorState());
    }
  }
}
