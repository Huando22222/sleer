import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactService {
  static Future<List<Contact>> fetchContacts() async {
    if (await Permission.contacts.isGranted) {
      return ContactsService.getContacts().then((contacts) {
        return contacts.toList();
      });
    } else {
      await Permission.contacts.request();
      if (await Permission.contacts.isGranted) {
        return ContactsService.getContacts().then((contacts) {
          return contacts.toList();
        });
      } else {
        return [];
      }
    }
  }
}
