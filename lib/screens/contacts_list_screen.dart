import 'package:flutter/material.dart';
import 'package:contact_app/db/database_helper.dart';
import 'package:contact_app/models/contact.dart';
import 'package:contact_app/widgets/contact_avatar.dart';

class ContactsListScreen extends StatefulWidget {
  @override
  _ContactsListScreenState createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  Future<List<Contact>>? _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() => setState(() => _future = DatabaseHelper.instance.getContacts());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        actions: [
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () => Navigator.pushNamed(context, '/favorites'),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: FutureBuilder<List<Contact>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) return Center(child: CircularProgressIndicator());
          final contacts = snap.data ?? [];
          if (contacts.isEmpty) return Center(child: Text('No contacts yet'));
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (ctx, i) {
              final c = contacts[i];
              return ListTile(
                leading: ContactAvatar(name: c.name, isFavorite: c.isFavorite),
                title: Text(c.name),
                subtitle: Text(c.phone),
                trailing: IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: () => Navigator.pushNamed(context, '/details', arguments: {'id': c.id}).then((_) => _reload()),
                ),
                onTap: () => Navigator.pushNamed(context, '/details', arguments: {'id': c.id}).then((_) => _reload()),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add').then((_) => _reload()),
        child: Icon(Icons.add),
      ),
    );
  }
}
