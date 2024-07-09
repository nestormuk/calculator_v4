import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactListScreen extends StatefulWidget {
  final Iterable<Contact> contacts;

  const ContactListScreen({Key? key, required this.contacts}) : super(key: key);

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact List'),
      ),
      body: ListView.builder(
        itemCount: widget.contacts.length,
        itemBuilder: (context, index) {
          Contact contact = widget.contacts.elementAt(index);
          return ListTile(
            title: Text(contact.displayName ?? ''),
            subtitle: Text(contact.phones?.isNotEmpty == true ? contact.phones!.first.value ?? '' : ''),
            onTap: () {
              // Handle contact tap
              // Example: Navigator.pop(context, contact);
            },
          );
        },
      ),
    );
  }
}
