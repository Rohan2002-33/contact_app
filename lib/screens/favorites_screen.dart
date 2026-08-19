import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../db/database_helper.dart';
import '../widgets/contact_avatar.dart';
import 'contact_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Contact> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final data = await DatabaseHelper.instance.getFavoriteContacts();
    setState(() => _favorites = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: _favorites.isEmpty
          ? const Center(child: Text('No favorite contacts yet'))
          : ListView.builder(
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final contact = _favorites[index];
                return ListTile(
                  leading: ContactAvatar(name: contact.name),
                  title: Text(contact.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(contact.phone),
                  trailing: const Icon(Icons.star, color: Colors.amber),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ContactDetailsScreen(contact: contact)),
                    );
                    _loadFavorites();
                  },
                );
              },
            ),
    );
  }
}