import 'package:flutter/material.dart';
import 'package:contact_management_app/model/db_helper.dart';

class ContactProvider extends ChangeNotifier {
  List<Map<String, dynamic>> contacts = [];

  Future<void> fetchContacts() async {
    final data = await SQLHelper.getContacts();
    contacts = data;
    notifyListeners();
  }
  

  Future<int> createContact(String firstName, String lastName, String phoneNumber, String email) async {
    final int id = await SQLHelper.createContact(firstName, lastName, phoneNumber, email);
    if (id != -1) {
      await fetchContacts(); 
    }
    return id;
  }


  Future<void> updateContact(int id, String firstName, String lastName, String phoneNumber, String email) async {
    await SQLHelper.updateContact(id, firstName, lastName, phoneNumber, email);
    await fetchContacts(); 
  }


  Future<void> deleteContact(int id) async {
    await SQLHelper.deleteContact(id);
    await fetchContacts(); 
  }
}
