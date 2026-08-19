import 'package:flutter/material.dart';
import 'package:contact_app/db/database_helper.dart';
import 'package:contact_app/models/contact.dart';
import 'package:contact_app/widgets/contact_avatar.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  Future<List<Contact>>? _future;

  @override
  void initState() {
    super.initState();
    _future = DatabaseHelper.instance.getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: FutureBuilder<List<Contact>>(
        future: _future,
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done) return Center(child: CircularProgressIndicator());
          final items = snap.data ?? [];
          if (items.isEmpty) return Center(child: Text('No favorites'));
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, i) {
              final c = items[i];
              return ListTile(
                leading: ContactAvatar(name: c.name, isFavorite: c.isFavorite),
                title: Text(c.name),
                subtitle: Text(c.phone),
                onTap: () => Navigator.pushNamed(context, '/details', arguments: {'id': c.id}),
              );
            },
          );
        },
      ),
    );
  }
}
