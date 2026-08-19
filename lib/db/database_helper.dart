import 'dart:async';
import 'package:contact_app/models/contact.dart';

/// Simple in-memory database helper for demonstration and assignments.
class DatabaseHelper {
  DatabaseHelper._init();
  static final DatabaseHelper instance = DatabaseHelper._init();

  final List<Contact> _contacts = [];
  int _autoIncrementId = 1;

  Future<List<Contact>> getContacts() async {
    await Future.delayed(Duration(milliseconds: 50));
    return List.unmodifiable(_contacts);
  }

  Future<Contact> addContact(Contact c) async {
    final contact = c.copyWith(id: _autoIncrementId++);
    _contacts.add(contact);
    return contact;
  }

  Future<void> updateContact(Contact contact) async {
    final idx = _contacts.indexWhere((c) => c.id == contact.id);
    if (idx >= 0) _contacts[idx] = contact;
  }

  Future<void> deleteContact(int id) async {
    _contacts.removeWhere((c) => c.id == id);
  }

  Future<Contact?> getContactById(int? id) async {
    if (id == null) return null;
    return _contacts.firstWhere((c) => c.id == id, orElse: () => null);
  }

  Future<List<Contact>> getFavorites() async {
    await Future.delayed(Duration(milliseconds: 30));
    return _contacts.where((c) => c.isFavorite).toList(growable: false);
  }

  Future<void> toggleFavorite(int id) async {
    final idx = _contacts.indexWhere((c) => c.id == id);
    if (idx >= 0) {
      final c = _contacts[idx];
      _contacts[idx] = c.copyWith(isFavorite: !c.isFavorite);
    }
  }
}
