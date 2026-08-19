import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../db/database_helper.dart';
import '../widgets/contact_avatar.dart';
import 'add_contact_screen.dart';
import 'contact_details_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

class ContactsListScreen extends StatefulWidget {
  const ContactsListScreen({super.key});

  @override
  State<ContactsListScreen> createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  List<Contact> _contacts = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final data = await DatabaseHelper.instance.getAllContacts();
    setState(() => _contacts = data);
  }

  Future<void> _search(String query) async {
    if (query.isEmpty) {
      _loadContacts();
      return;
    }
    final data = await DatabaseHelper.instance.searchContacts(query);
    setState(() => _contacts = data);
  }

  Future<void> _toggleFavorite(Contact contact) async {
    final updated = contact.copyWith(
      isFavorite: contact.isFavorite == 1 ? 0 : 1,
    );
    await DatabaseHelper.instance.updateContact(updated);
    _loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search contacts...',
                  border: InputBorder.none,
                ),
                onChanged: _search,
              )
            : const Text('My Contacts'),
        leading: _isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                  });
                  _loadContacts();
                },
              )
            : null,
        actions: [
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => setState(() => _isSearching = true),
            )
          else
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _loadContacts();
              },
            ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.people, color: Colors.white, size: 40),
                  SizedBox(height: 8),
                  Text('My Contacts',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  Text('Manage your friends easily',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Contacts'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.star_border),
              title: const Text('Favorites'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const FavoritesScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Add Contact'),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AddContactScreen()));
                _loadContacts();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About App'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()));
              },
            ),
          ],
        ),
      ),
      body: _contacts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.contact_page_outlined,
                      size: 100, color: Colors.deepPurple),
                  const SizedBox(height: 16),
                  const Text('No contacts yet',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Add your first contact by tapping\nthe + button below.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                final contact = _contacts[index];
                return ListTile(
                  leading: ContactAvatar(name: contact.name),
                  title: Text(contact.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${contact.email}\n${contact.phone}'),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: Icon(
                      contact.isFavorite == 1 ? Icons.star : Icons.star_border,
                      color: contact.isFavorite == 1 ? Colors.amber : Colors.grey,
                    ),
                    onPressed: () => _toggleFavorite(contact),
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ContactDetailsScreen(contact: contact)),
                    );
                    _loadContacts();
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AddContactScreen()));
          _loadContacts();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}