import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../db/database_helper.dart';
import '../widgets/contact_avatar.dart';
import 'contact_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Contact> _results = [];

  Future<void> _search(String query) async {
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }
    final data = await DatabaseHelper.instance.searchContacts(query);
    setState(() => _results = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  onChanged: _search,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Search contacts...',
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _controller.clear();
                              _search('');
                            },
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: _results.isEmpty
          ? const Center(
              child: Text('Type a name to search', style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final contact = _results[index];
                return ListTile(
                  leading: ContactAvatar(name: contact.name),
                  title: Text(contact.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(contact.phone),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ContactDetailsScreen(contact: contact)),
                    );
                  },
                );
              },
            ),
    );
  }
}