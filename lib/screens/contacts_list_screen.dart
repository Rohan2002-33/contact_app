import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../db/database_helper.dart';
import '../widgets/contact_avatar.dart';
import '../main.dart';
import 'add_contact_screen.dart';
import 'contact_details_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';
import 'search_screen.dart';

class ContactsListScreen extends StatefulWidget {
  const ContactsListScreen({super.key});

      appBar: AppBar(
        title: const Text('My Contacts'),
        centerTitle: false,
        leading: Builder(builder: (ctx) {
          return IconButton(icon: const Icon(Icons.menu), onPressed: () => Scaffold.of(ctx).openDrawer());
        }),
        actions: [
          if (!_isSearching)
            IconButton(icon: const Icon(Icons.search), onPressed: () => setState(() => _isSearching = true))
          else
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                });
                _loadContacts();
              },
            ),
        ],
        bottom: _isSearching
            ? PreferredSize(
                preferredSize: const Size.fromHeight(64),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2))],
                    ),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search contacts...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      onChanged: _search,
                    ),
                  ),
                ),
              )
            : null,
      ),
                  const Divider(height: 1, indent: 72, color: Color(0xFFEDEDF3)),
              itemBuilder: (context, index) {
                final contact = _contacts[index];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  leading: ContactAvatar(name: contact.name),
                  title: Text(contact.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    '${contact.email}\n${contact.phone}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: const BoxDecoration(
              color: kPrimaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.contact_page_rounded,
                size: 70, color: kPrimaryColor),
          ),
          const SizedBox(height: 20),
          const Text('No contacts yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text(
            'Add your first contact by tapping\nthe + button below.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
            color: kPrimaryColor,
            width: double.infinity,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.people_alt_rounded, color: Colors.white, size: 40),
                SizedBox(height: 10),
                Text('My Contacts',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Text('Manage your friends easily',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: kPrimaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: const Icon(Icons.person, color: kPrimaryColor),
              title: const Text('My Contacts',
                  style: TextStyle(
                      color: kPrimaryColor, fontWeight: FontWeight.w600)),
              onTap: () => Navigator.pop(context),
            ),
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
            leading: const Icon(Icons.person_add_alt),
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
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}